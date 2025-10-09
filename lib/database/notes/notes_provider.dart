import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/cache/notes_cache.dart';
import 'package:logosophy/database/notes/models/note.dart';
import 'package:logosophy/database/notes/models/notes_state.dart';
import 'package:logosophy/utils/encryption_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_provider.g.dart';

@Riverpod(keepAlive: true)
class NotesNotifier extends _$NotesNotifier {
  final _logger = Logger('NotesNotifier');

  @override
  NotesState build() {
    return NotesState(notes: {});
  }

  DocumentReference<Map<String, dynamic>>? _getDocRef() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _logger.shout('User instance is null.');
      return null;
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('userData')
        .doc('notes');
  }

  Future<void> getDocument() async {
    final docRef = _getDocRef();
    if (docRef == null) return;

    final source = NotesCache().isFresh() ? Source.cache : Source.server;
    final docSnapshot = await docRef.get(GetOptions(source: source));

    if (docSnapshot.exists) {
      _logger.info('Got notes document from Firestore.');
      state = NotesState.fromJson(docSnapshot.data()!);

      if (source == Source.server) {
        NotesCache().update();
      }
    } else {
      _logger.shout('Could not find Notes document from Firestore.');
    }
  }

  /// Saves a new note or updates an existing one.
  Future<void> saveNote(Note note) async {
    final docRef = _getDocRef();
    if (docRef == null) return;

    final encryptedText = EncryptionUtils().encrypt(note.note);
    if (encryptedText == null) {
      _logger.shout('Error encrypting notes. Aborting...');
      return;
    }

    Note noteToSave = note.copyWith(
      id: note.id ?? docRef.collection('_').doc().id,
      note: encryptedText,
      createdAt: note.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final newNotesMap = Map<String, Note>.from(state.notes);
    final id = noteToSave.id!;
    newNotesMap[id] = noteToSave;
    state = state.copyWith(notes: newNotesMap);

    try {
      await docRef.update({'notes.$id': noteToSave.toJson()});
      _logger.info('Successfully saved note with id: $id');
    } catch (e) {
      _logger.severe('Failed to save note: $e');
    }
  }

  /// Deletes a note from local state and Firebase.
  Future<void> deleteNote({required String id}) async {
    final docRef = _getDocRef();
    if (docRef == null) return;

    final newNotesMap = Map<String, Note>.from(state.notes);
    newNotesMap.remove(id);
    state = state.copyWith(notes: newNotesMap);

    try {
      await docRef.update({'notes.$id': FieldValue.delete()});
      _logger.info('Successfully deleted note with id: $id');
    } catch (e) {
      _logger.severe('Failed to delete note: $e');
    }
  }

  /// Returns a list of notes based on optional filter criteria.
  ///
  /// [bookId] - If provided, only notes from this book will be returned.
  ///
  /// [page] - If provided, only notes from this page will be returned.
  ///
  /// [after] - If provided, only notes created after this DateTime will be returned.
  ///
  /// [before] - If provided, only notes created before this DateTime will be returned.
  List<Note> getNotes({String? bookId, DateTime? after, DateTime? before}) {
    // Start with an iterable of all notes from the current state.
    Iterable<Note> filteredNotes = state.notes.values;

    // Apply bookId filter if it exists.
    if (bookId != null) {
      filteredNotes = filteredNotes.where((note) => note.bookId == bookId);
    }

    // Apply 'after' date filter if it exists.
    if (after != null) {
      filteredNotes = filteredNotes.where((note) {
        // Safely check if createdAt is not null before comparing.
        return note.createdAt != null && note.createdAt!.isAfter(after);
      });
    }

    // Apply 'before' date filter if it exists.
    if (before != null) {
      filteredNotes = filteredNotes.where((note) {
        // Safely check if createdAt is not null before comparing.
        return note.createdAt != null && note.createdAt!.isBefore(before);
      });
    }

    // Return the final filtered list.
    return filteredNotes.toList();
  }
}
