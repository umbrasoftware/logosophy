import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/annotations/models/annotations_state.dart';
import 'package:logosophy/database/annotations/models/page_annotations.dart';
import 'package:logosophy/database/cache/annotations_cache.dart';
import 'package:logosophy/utils/pdf_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'models/selection_span.dart';

part 'annotations_provider.g.dart';

@Riverpod(keepAlive: true)
class AnnotationsNotifier extends _$AnnotationsNotifier {
  final _logger = Logger('AnnotationsNotifier');

  @override
  AnnotationsState build() {
    return AnnotationsState(book: {});
  }

  /// Get the [SelectionSpan] for page, if provided. If not, the entire
  /// [SelectionSpan] for the book will be returned.
  List<SelectionSpan> getSelectionSpans(String bookId, {String? page}) {
    if (page != null) {
      return state.book[bookId]?.page[page] ?? [];
    } else {
      final List<SelectionSpan> allSpans = [];
      if (state.book[bookId] == null) return [];

      for (final spans in state.book[bookId]!.page.values) {
        for (final span in spans) {
          allSpans.add(span);
        }
      }

      return allSpans;
    }
  }

  /// Gets the entire Annotation document from Firebase.
  Future<void> getAnnotationsDoc() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _logger.shout('User instance is null.');
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('userData')
        .doc('annotations');

    final source = AnnotationsCache().isFresh() ? Source.cache : Source.server;
    final docSnapshot = await docRef.get(GetOptions(source: source));

    if (docSnapshot.exists) {
      _logger.info('Got annotations document from Firestore.');
      state = AnnotationsState.fromJson(docSnapshot.data()!);

      if (source == Source.server) {
        AnnotationsCache().update();
      }
    }
  }

  /// Saves annotations from a specific book and page to Firebase.
  Future<void> save(String bookId, String page) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _logger.shout('User instance is null.');
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('userData')
        .doc('annotations');

    final annotationsInPage = state.book[bookId]?.page[page];
    await docRef.set({"book.$bookId.page.$page": annotationsInPage});

    _logger.info('Book $bookId, page $page was saved on Firebase.');
  }

  /// Removes a [SelectionSpan] from the current book state. If sucessuful,
  /// returns the new list of spans without the `spanToRemove`. Otherwise,
  /// returns null.
  List<SelectionSpan>? removeAnnotationFromBook(
    String bookId,
    SelectionSpan spanToRemove,
  ) {
    final page = spanToRemove.pageNumber.toString();
    final selections = state.book[bookId]!.page[page];
    if (selections == null) return null;

    final List<SelectionSpan> spansToKeep = [];
    for (final span in selections) {
      if (!PDFUtils.compareSelectionSpans(spanToRemove, span)) {
        spansToKeep.add(span);
      }
    }

    // 1. Crie uma cópia modificável do mapa de livros.
    final newBookMap = Map<String, PageAnnotations>.from(state.book);

    // 2. Pegue o livro específico e crie uma cópia do seu mapa de páginas.
    final bookToUpdate = newBookMap[bookId]!;
    final newPageMap = Map<String, List<SelectionSpan>>.from(bookToUpdate.page);

    // 3. Modifique a cópia do mapa de páginas com os novos dados.
    newPageMap[page] = spansToKeep;

    // 4. Crie uma nova instância do livro atualizado com o mapa de páginas modificado.
    final updatedBook = bookToUpdate.copyWith(page: newPageMap);

    // 5. Coloque o livro atualizado de volta no mapa de livros principal.
    newBookMap[bookId] = updatedBook;

    // 6. Finalmente, atualize o estado com o mapa de livros totalmente novo.
    state = state.copyWith(book: newBookMap);

    return spansToKeep;
  }

  /// Updates a selection for a specific page on Firebase.
  /// The new selection should be all the selections for the page, not just the
  /// want you want to be updated or inserted.
  /// Updates selections for a specific page on Firebase and in the local state.
  Future<void> updateSelectionsForPage(
    String bookId,
    String pageNumber,
    List<SelectionSpan> newSelectionsForPage,
  ) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _logger.warning('User not available. Aborting update.');
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('userData')
        .doc('annotations');

    // The field path must match the nested structure of your state objects:
    // AnnotationsState -> 'book' property -> bookId -> 'page' property -> pageNumber
    final fieldPath = 'book.$bookId.page.$pageNumber';

    try {
      // Step 1: Update the remote state in Firestore.
      if (newSelectionsForPage.isEmpty) {
        // If the new list is empty, delete the field for this page in Firestore.
        await docRef.update({fieldPath: FieldValue.delete()});
      } else {
        // Otherwise, update or create the field with the new selections.
        await docRef.update({
          fieldPath: newSelectionsForPage.map((s) => s.toJson()).toList(),
        });
      }

      // Step 2: Update the local state immutably.

      // Create a mutable copy of the main book map from the current state.
      final newBookMap = Map<String, PageAnnotations>.from(state.book);

      // Get the current annotations for the book, or create a new empty one if it's the first annotation.
      final oldBookAnnotations =
          state.book[bookId] ?? PageAnnotations(page: {});

      // Create a mutable copy of that book's page map.
      final newPageMap = Map<String, List<SelectionSpan>>.from(
        oldBookAnnotations.page,
      );

      // Apply the change to the copied page map.
      if (newSelectionsForPage.isEmpty) {
        newPageMap.remove(pageNumber);
      } else {
        newPageMap[pageNumber] = newSelectionsForPage;
      }

      // Create a new, immutable PageAnnotations object with the updated page map.
      final updatedBook = oldBookAnnotations.copyWith(page: newPageMap);

      // Place the updated book back into the main book map copy.
      newBookMap[bookId] = updatedBook;

      // Finally, update the entire state with the new book map.
      state = state.copyWith(book: newBookMap);

      _logger.info(
        'Successfully updated local and remote state for page $pageNumber in book $bookId.',
      );
    } catch (e) {
      _logger.severe('Failed to update selections for page $pageNumber: $e');
    }
  }
}
