import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:logosophy/database/books/book_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'book_provider.g.dart';

/// Provider responsable for holding the search history. The state is always sorted by
/// the most recent.
@Riverpod(keepAlive: true)
class BookNotifier extends _$BookNotifier {
  final _logger = Logger('BookCache');
  static const String prefsName = 'books';
  String language = 'pt-BR';
  late SharedPreferencesWithCache _prefs;

  late Map<String, dynamic> mappings;
  late Directory langDir;

  @override
  Future<List<BookData>> build() async {
    await _getVariables();

    _prefs = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());
    final booksPrefs = _prefs.getString(prefsName);
    if (booksPrefs == null || booksPrefs.isEmpty || booksPrefs == '{}') {
      return _getStateFromScratch();
    }

    return _loadState(booksPrefs);
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

    final prefs = {};
    final List<BookData> booksData = [];

    for (var entity in entities) {
      if (entity is! File) continue;

      final fileName = p.basename(entity.path);
      if (!fileName.endsWith('.pdf')) continue;

      final String bookId = fileName.split(".")[0];

      final bookPath = entity.path;
      final coverPath = entity.path.replaceFirst('$bookId.pdf', '${bookId}_cover.png');
      final title = mappings['pt-BR']['$bookId.pdf']['title'];
      final lastOpened = DateTime.now().toIso8601String();

      prefs[bookId] = {
        "bookId": bookId,
        "bookPath": bookPath,
        "coverPath": coverPath,
        "title": title,
        "lastOpened": lastOpened,
        "x": 1.0,
        "y": 1.0,
        "zoom": 1.0,
      };

      booksData.add(
        BookData(
          bookId: bookId,
          bookPath: bookPath,
          coverPath: coverPath,
          title: title,
          lastOpened: lastOpened,
          x: 1.0,
          y: 1.0,
          zoom: 1.0,
        ),
      );

      daysOffset++;
      time = time.subtract(Duration(days: daysOffset));
    }

    await _prefs.setString(prefsName, jsonEncode(prefs));
    return booksData;
  }

  /// Loads and gets this Provider state from SharedPrefs.
  Future<List<BookData>> _loadState(String booksPrefs) async {
    _logger.info("Getting state from SharedPrefs...");
    final Map<String, dynamic> prefsJson = json.decode(booksPrefs);
    final List<BookData> newState = [];

    for (final entry in prefsJson.entries) {
      final values = entry.value;
      newState.add(
        BookData(
          bookId: entry.key,
          coverPath: values["coverPath"],
          bookPath: values["bookPath"],
          title: values["title"],
          lastOpened: values["lastOpened"],
          x: values["x"],
          y: values["y"],
          zoom: values["zoom"],
        ),
      );
    }
    return newState;
  }

  /// Get a postition for a given `bookId`.
  BookData? getPosition(String bookId) {
    if (state.value == null) {
      _logger.shout('State is null while trying to get book position.');
      return null;
    }
    return state.value!.firstWhere((book) => book.bookId == bookId);
  }

  /// Saves the position state for the `bookId`.
  Future<void> savePosition(String bookId, double zoom, Offset offset) async {
    _logger.info("Cheking app directory...");
    final prefString = _prefs.getString(prefsName);
    if (state.value == null || prefString == null) {
      _logger.shout('State or Prefs is null while trying to save book position.');
      return;
    }

    // Update the SharedPrefs.
    final prefsJson = jsonDecode(prefString);
    final bookMap = prefsJson[bookId];
    bookMap['zoom'] = zoom;
    bookMap['offsetX'] = offset.dx;
    bookMap['offsetY'] = offset.dy;
    prefsJson[bookId] = bookMap;
    await _prefs.setString(prefsName, jsonEncode(prefsJson));

    // Update the state.
    final modifiableState = [...state.value!];
    final index = modifiableState.indexWhere((book) => book.bookId == bookId);
    if (index == -1) return;

    final newBookData = modifiableState[index].copyWith(x: offset.dx, y: offset.dy, zoom: zoom);
    modifiableState[index] = newBookData;
    state = AsyncData(modifiableState);
  }

  /// Saves a book's Timestamp.
  Future<void> saveTimestamp(String bookId) async {
    final data = _prefs.getString(prefsName);
    if (data == null || !state.hasValue) {
      _logger.severe("SharedPrefs or state is null while trying to save $bookId timestamp.");
      return;
    }
    final now = DateTime.now().toIso8601String();
    final dataJson = jsonDecode(data);
    dataJson[bookId]['lastOpened'] = now;
    await _prefs.setString(prefsName, jsonEncode(dataJson));

    final newState = [...state.requireValue];
    final index = newState.indexWhere((book) => book.bookId == bookId);
    newState[index] = newState[index].copyWith(lastOpened: now);
    newState.sort((a, b) => DateTime.parse(b.lastOpened).compareTo(DateTime.parse(a.lastOpened)));
    state = AsyncData(newState);
  }
}
