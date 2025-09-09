import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/selection/selections_classes.dart';

class PDFUtils {
  static final _logger = Logger('PdfUtils');

  /// Saves a text selection (highlight, underline, etc.) to a specific book
  /// document in Firestore.
  static Future<bool> saveBookSelectionOnFirebase(
    String bookId,
    List<SelectionSpan> selections,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _logger.warning('Cannot save selection: User is not logged in.');
      return false;
    }

    final firestore = FirebaseFirestore.instance;

    // This is the key part: we build a path to the specific document.
    // For your example, if bookId is '005', the path will be:
    // users/{currentUser.uid}/books/005
    final bookRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('books')
        .doc(bookId);

    try {
      // Convert the page number to a string for the map key.
      final selectionPageKey = selections.first.pageNumber.toString();

      // Convert the list of selection objects to a list of JSON maps.
      final selectionsAsJson = selections.map((s) => s.toJson()).toList();

      // Use .update() to set or replace the array for the given page key.
      await bookRef.update({'selections.$selectionPageKey': selectionsAsJson});

      _logger.info('Successfully saved selection for book $bookId');
      return true;
    } catch (e) {
      _logger.severe('Failed to save selection for book $bookId: $e');
      return false;
    }
  }

  /// Retrieves all selections for a specific page of a book from Firestore.
  static Future<List<SelectionSpan>> getSelections(String bookId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _logger.warning('Cannot get selections: User is not logged in.');
      return [];
    }

    final firestore = FirebaseFirestore.instance;
    final bookRef = firestore
        .collection('users')
        .doc(user.uid)
        .collection('books')
        .doc(bookId);

    try {
      final docSnapshot = await bookRef.get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        _logger.info(
          'Book document $bookId does not exist for user ${user.uid}.',
        );
        return [];
      }

      final data = docSnapshot.data()!;
      // TODO: Complete this logic!
    } catch (e) {
      _logger.severe('Failed to get selections for book $bookId: $e');
      return [];
    }
  }
}
