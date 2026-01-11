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
class BookData {
  BookData._internal();
  static final BookData _instance = BookData._internal();
  factory BookData() => _instance;

  final _logger = Logger('BookCache');
  late SharedPreferencesWithCache _prefs;

  /// Initializes the class singleton. Must be called before everything else.
  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());

    if (_prefs.getString('books') == null) {
      await _prefs.setString('books', json.encode(bookMap));
    }
  }

  /// Get a postition for a given `bookId`.
  BookPosition getPosition(String bookId) {
    final data = _prefs.getString('books');
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
    final data = _prefs.getString('books');
    if (data != null) {
      final dataJson = jsonDecode(data);
      final bookData = dataJson[bookId];
      bookData['zoom'] = zoom;
      bookData['offsetX'] = offset.dx;
      bookData['offsetY'] = offset.dy;
      dataJson[bookId] = bookData;
      await _prefs.setString('books', jsonEncode(dataJson));
    }
  }
}

const bookMap = {
  "001": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "002": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "003": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "004": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "005": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "006": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "007": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "008": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "009": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "010": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "011": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "012": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "013": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "014": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "015": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "016": {"offsetX": 0, "offsetY": 0, "zoom": 1},
  "017": {"offsetX": 0, "offsetY": 0, "zoom": 1},
};
