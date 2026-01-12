import 'dart:convert';
import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Data model for a book. Define the position state.
class BookPosition {
  final double zoom;
  final Offset offset;

  BookPosition({this.zoom = 1.0, this.offset = Offset.zero});

  @override
  String toString() {
    return 'BookPosition{zoom: $zoom, offset: $offset}';
  }
}

/// This class is responsible for saving the read state for every books.
/// This mean the page, scroll position and zoom state.
class BookReadStatus {
  BookReadStatus._internal();
  static final BookReadStatus _instance = BookReadStatus._internal();
  factory BookReadStatus() => _instance;

  final _logger = Logger('BookCache');
  static const String prefsName = 'books';
  late SharedPreferencesWithCache _prefs;

  /// Initializes the class singleton. Must be called before everything else.
  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());
    final booksData = _prefs.getString(prefsName);

    if (booksData == null) {
      DateTime time = DateTime.now().subtract(const Duration(days: 180));
      int count = 0;
      final finalBookMap = json.decode(json.encode(bookMap));

      for (final entries in bookMap.entries) {
        finalBookMap[entries.key]!["lastOpened"] = time.toIso8601String();
        count++;
        time = time.subtract(Duration(days: count));
      }

      await _prefs.setString(prefsName, json.encode(finalBookMap));
    }
  }

  /// Get a postition for a given `bookId`.
  BookPosition getPosition(String bookId) {
    final data = _prefs.getString(prefsName);
    if (data != null) {
      final dataJson = jsonDecode(data);
      final bookData = dataJson[bookId];
      return BookPosition(
        zoom: (bookData['zoom'] as num?)?.toDouble() ?? 1.0,
        offset: Offset(
          (bookData['offsetX'] as num?)?.toDouble() ?? 0.0,
          (bookData['offsetY'] as num?)?.toDouble() ?? 0.0,
        ),
      );
    }

    _logger.warning('Book $bookId position is null. Creating default.');
    return BookPosition();
  }

  /// Saves the position state for the `bookId`.
  Future<void> savePosition(String bookId, double zoom, Offset offset) async {
    final data = _prefs.getString(prefsName);
    if (data != null) {
      final dataJson = jsonDecode(data);
      final bookData = dataJson[bookId];
      bookData['zoom'] = zoom;
      bookData['offsetX'] = offset.dx;
      bookData['offsetY'] = offset.dy;
      dataJson[bookId] = bookData;
      await _prefs.setString(prefsName, jsonEncode(dataJson));
    }
  }

  /// Saves a book's Timestamp.
  Future<void> saveTimestamp(String bookId) async {
    final data = _prefs.getString(prefsName);
    if (data == null) {
      _logger.severe("SharedPrefs is null while trying to save $bookId timestamp.");
      return;
    }
    final dataJson = jsonDecode(data);
    dataJson[bookId]['lastOpened'] = DateTime.now().toIso8601String();
    await _prefs.setString(prefsName, jsonEncode(dataJson));
  }

  Future<Map<String, dynamic>?> getReadStatus() async {
    String? data = _prefs.getString(prefsName);
    if (data == null) {
      _logger.severe("SharedPrefs is null while trying to get all books status. Calling init() again.");
      await init();
    }

    data = _prefs.getString(prefsName);
    if (data == null) {
      _logger.severe("SharedPrefs is still null AFTER callin init(). Giving up!");
      return null;
    }

    return jsonDecode(data);
  }
}

const bookMap = {
  "001": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "002": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "003": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "004": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "005": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "006": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "007": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "008": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "009": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "010": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "011": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "012": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "013": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "014": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "015": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "016": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "017": {"lastOpened": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
};
