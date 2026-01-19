import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/books/book_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'book_provider.g.dart';

/// Provider responsable for holding the book status. The state is always sorted by
/// the most recent. The Provider state is always sorted.
@Riverpod(keepAlive: true)
class BookNotifier extends _$BookNotifier {
  final _logger = Logger('BookNotifier');
  String language = 'pt-BR';
  late Box<BookData> _box;

  late Map<String, dynamic> mappings;
  late Directory langDir;

  @override
  Future<List<BookData>> build() async {
    _box = await Hive.openBox<BookData>('books');
    await _getVariables();

    if (_box.isEmpty) {
      return _getStateFromScratch();
    }

    return _loadState();
  }

  /// Get the variables for this Provider to work. It assumes everything is
  /// already setup.
  Future<void> _getVariables() async {
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(appDocumentsDir.path, 'books'));
    langDir = Directory(p.join(booksDir.path, language));

    final mappingsFile = File(p.join(booksDir.path, 'mappings.json'));
    final mappingsContent = await mappingsFile.readAsString();
    mappings = jsonDecode(mappingsContent);
  }

  /// Get this Provider state and set SharedPrefs.
  Future<List<BookData>> _getStateFromScratch() async {
    _logger.info("Starting Provider from fresh state.");
    int daysOffset = 1;
    DateTime time = DateTime.now().subtract(const Duration(days: 180));
    final entities = langDir.listSync();

    final List<BookData> booksData = [];

    for (var entity in entities) {
      if (entity is! File) continue;

      final fileName = p.basename(entity.path);
      if (!fileName.endsWith('.pdf')) continue;

      final String bookId = fileName.split(".")[0];

      final bookPath = entity.path;
      final coverPath = entity.path.replaceFirst('$bookId.pdf', '${bookId}_cover.png');
      final title = mappings['pt-BR']['$bookId.pdf']['title'];
      final lastOpened = DateTime.now();

      final book = BookData(
        bookId: bookId,
        bookPath: bookPath,
        coverPath: coverPath,
        title: title,
        lastOpened: lastOpened,
        x: 1.0,
        y: 1.0,
        zoom: 1.0,
      );

      booksData.add(book);
      await _box.put(book.bookId, book);

      daysOffset++;
      time = time.subtract(Duration(days: daysOffset));
    }

    booksData.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));
    return booksData;
  }

  /// Loads and gets this Provider state from SharedPrefs.
  Future<List<BookData>> _loadState() async {
    _logger.info("Getting state from Hive...");
    final List<BookData> newState = [];

    for (final book in _box.values) {
      newState.add(
        BookData(
          bookId: book.bookId,
          bookPath: book.bookPath,
          coverPath: book.coverPath,
          title: book.title,
          lastOpened: book.lastOpened,
          x: book.x,
          y: book.y,
          zoom: book.zoom,
        ),
      );
    }

    newState.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));
    return newState;
  }

  /// Get a postition for a given `bookId`.
  BookData? getPosition(String bookId) {
    final bookOnBox = _getBookOnState(bookId);
    return bookOnBox?.book;
  }

  /// Saves the position state for the `bookId`.
  Future<void> savePosition(String bookId, double zoom, Offset offset) async {
    final bookInfo = _getBookOnState(bookId);
    if (bookInfo == null) return;

    int index = bookInfo.index;
    final newBook = bookInfo.book.copyWith(zoom: zoom, x: offset.dx, y: offset.dy);

    // Update the Hive box.
    await _box.put(newBook.bookId, newBook);

    // Update the state.
    final modifiableState = [...state.requireValue];
    modifiableState[index] = newBook;
    state = AsyncData(modifiableState);
  }

  /// Saves a book's Timestamp.
  Future<void> saveTimestamp(String bookId) async {
    final bookOnState = _getBookOnState(bookId);
    if (bookOnState == null) return;

    final now = DateTime.now();
    final index = bookOnState.index;
    final newBook = state.requireValue[index].copyWith(lastOpened: now);

    // Updates both the box...
    await _box.put(newBook.bookId, newBook);

    // and the Provider.
    final modifiableState = [...state.requireValue];
    modifiableState[index] = newBook;
    modifiableState.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));
    state = AsyncData(modifiableState);
  }

  /// Returns the book index and the [BookData] object by it's bookId, if found on [state].
  /// Null otherwise.
  BookInfo? _getBookOnState(String bookId) {
    if (!_isDataIntegrityOk()) return null;

    for (int i = 0; i < state.requireValue.length; i++) {
      final book = state.requireValue[i];
      if (book.bookId == bookId) {
        return BookInfo(i, book);
      }
    }

    _logger.shout("Book $bookId could not be found in the box.");
    return null;
  }

  /// Checks the data integrity for both the box and the Provider. Returns True on success.
  /// It logs if anything goes wrong.
  bool _isDataIntegrityOk() {
    if (_box.isEmpty) {
      _logger.shout("The box has not been initialized yet.");
      return false;
    }

    if (state.hasError) {
      _logger.shout("The Provider is in '.hasError' state: ${state.error}");
      return false;
    }

    if (state.isLoading) {
      _logger.shout("The Provider is still loading.");
      return false;
    }

    return true;
  }
}

class BookInfo {
  BookInfo(this.index, this.book);

  int index;
  BookData book;
}
