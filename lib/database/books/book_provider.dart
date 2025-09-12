import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/books/book.dart';
import 'package:logosophy/database/books/book_cache.dart';
import 'package:logosophy/database/books/notes.dart';
import 'package:logosophy/database/books/selection_span.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_provider.g.dart';

@Riverpod(keepAlive: true)
class BookNotifier extends _$BookNotifier {
  final _logger = Logger('BookNotifier');

  @override
  Book build() {
    return Book(bookId: 'null', selections: {}, notes: {});
  }

  /// Gets an entire book from Firebase. BookId must be padded with 3 zeros
  /// in it's left.
  Future<void> getBook(String bookId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _logger.shout('User instance is null.');
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('books')
        .doc(bookId);

    final source = BookCache().isBookFresh(bookId)
        ? Source.cache
        : Source.server;

    final docSnapshot = await docRef.get(GetOptions(source: source));

    if (docSnapshot.exists) {
      _logger.info('Got $bookId book from Firestore.');
      state = Book.fromJson(docSnapshot.data()!);

      if (source == Source.server) {
        BookCache().updateBook(bookId);
      }
    }
  }

  // Função para salvar o livro inteiro (sem alterações)
  Future<void> saveBook(Book book) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _logger.shout('User instance is null.');
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('books')
        .doc(book.bookId);

    final bookJson = book.toJson();
    await docRef.set(bookJson);
    state = book; // Atribui diretamente o objeto, não precisa converter de novo

    _logger.info('Book ${book.bookId} saved on Firebase.');
  }

  /// Atualiza as anotações para uma página específica usando a estrutura de Mapa.
  Future<void> updateNotesForPage(
    int pageNumber,
    List<Notes> newNotesForPage,
  ) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || state.bookId == 'null') {
      _logger.warning('User or Book not available. Aborting update.');
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('books')
        .doc(state.bookId);

    // Constrói o caminho para o campo aninhado no mapa. Ex: "notes.5"
    final fieldPath = 'notes.$pageNumber';

    try {
      // Se a lista de novas anotações estiver vazia, removemos a entrada do mapa.
      if (newNotesForPage.isEmpty) {
        // Usa FieldValue.delete() para remover a chave do mapa no Firestore.
        await docRef.update({fieldPath: FieldValue.delete()});

        // Atualiza o estado local removendo a chave do mapa.
        final updatedMap = Map<String, List<Notes>>.from(state.notes)
          ..remove(pageNumber.toString());
        state = state.copyWith(notes: updatedMap);
        _logger.info(
          'Notes for page $pageNumber in book ${state.bookId} deleted.',
        );
      } else {
        // Se houver anotações, atualizamos ou criamos a entrada no mapa.
        await docRef.update({
          fieldPath: newNotesForPage.map((n) => n.toJson()).toList(),
        });

        // Atualiza o estado local adicionando/modificando a entrada no mapa.
        final updatedMap = Map<String, List<Notes>>.from(state.notes)
          ..[pageNumber.toString()] = newNotesForPage;
        state = state.copyWith(notes: updatedMap);
        _logger.info(
          'Notes for page $pageNumber in book ${state.bookId} updated.',
        );
      }
    } catch (e) {
      _logger.severe('Failed to update notes for page $pageNumber: $e');
    }
  }

  /// Atualiza as seleções para uma página específica usando a estrutura de Mapa.
  Future<void> updateSelectionsForPage(
    int pageNumber,
    List<SelectionSpan> newSelectionsForPage,
  ) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || state.bookId == 'null') {
      _logger.warning('User or Book not available. Aborting update.');
      return;
    }

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('books')
        .doc(state.bookId);

    // Exatamente como você intuiu: "selections.5", "selections.8", etc.
    final fieldPath = 'selections.$pageNumber';

    try {
      // Caso de DELEÇÃO: se a nova lista estiver vazia, removemos a chave.
      if (newSelectionsForPage.isEmpty) {
        await docRef.update({fieldPath: FieldValue.delete()});

        final updatedMap = Map<String, List<SelectionSpan>>.from(
          state.selections,
        )..remove(pageNumber.toString());
        state = state.copyWith(selections: updatedMap);
        _logger.info(
          'Selections for page $pageNumber in book ${state.bookId} deleted.',
        );
      } else {
        // Caso de ATUALIZAÇÃO/CRIAÇÃO
        await docRef.update({
          fieldPath: newSelectionsForPage.map((s) => s.toJson()).toList(),
        });

        final updatedMap = Map<String, List<SelectionSpan>>.from(
          state.selections,
        )..[pageNumber.toString()] = newSelectionsForPage;
        state = state.copyWith(selections: updatedMap);
        _logger.info(
          'Selections for page $pageNumber in book ${state.bookId} updated.',
        );
      }
    } catch (e) {
      _logger.severe('Failed to update selections for page $pageNumber: $e');
    }
  }
}
