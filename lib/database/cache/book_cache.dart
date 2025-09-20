import 'dart:convert';
import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookPosition {
  final double zoom;
  final Offset offset;

  BookPosition({this.zoom = 1.0, this.offset = Offset.zero});

  @override
  String toString() {
    return 'BookPosition{zoom: $zoom, offset: $offset}';
  }
}

class BookCache {
  BookCache._internal();
  static final BookCache _instance = BookCache._internal();
  factory BookCache() => _instance;

  static const int updateTimeMin = 180;

  final _logger = Logger('BookCache');
  late SharedPreferencesWithCache _prefs;

  void init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

    if (_prefs.getString('books') == null) {
      await _prefs.setString('books', json.encode(bookMap));
    }
  }

  void update(String bookId) {
    final data = _prefs.getString('books');
    if (data != null) {
      final dataJson = jsonDecode(data);
      dataJson[bookId]['refreshedAt'] = DateTime.now().toIso8601String();
      _prefs.setString('books', jsonEncode(dataJson));
    }
  }

  bool isFresh(String bookId) {
    final data = _prefs.getString('books');
    if (data != null) {
      final dataJson = jsonDecode(data);
      final lastUpdate = dataJson[bookId]['refreshedAt'];
      if (lastUpdate != null && lastUpdate.isNotEmpty) {
        final lastUpdateDateTime = DateTime.parse(lastUpdate);
        final now = DateTime.now();
        final diff = now.difference(lastUpdateDateTime);
        final isFresh = diff.inMinutes < updateTimeMin;
        _logger.info('Book $bookId is ${isFresh ? '' : 'not '}fresh');
        return isFresh;
      }
    }
    _logger.info('Book $bookId is not fresh');
    return false;
  }

  BookPosition getPosition(String bookId) {
    final data = _prefs.getString('books');
    if (data != null) {
      final dataJson = jsonDecode(data);
      final bookData = dataJson[bookId];
      if (bookData != null) {
        return BookPosition(
          zoom: (bookData['zoom'] as num?)?.toDouble() ?? 1.0,
          offset: Offset(
            (bookData['offsetX'] as num?)?.toDouble() ?? 0.0,
            (bookData['offsetY'] as num?)?.toDouble() ?? 0.0,
          ),
        );
      }
    }
    return BookPosition();
  }

  void savePosition(String bookId, {int? page, double? zoom, Offset? offset}) {
    final data = _prefs.getString('books');
    if (data != null) {
      final dataJson = jsonDecode(data);
      final bookData = dataJson[bookId] ?? {};
      if (zoom != null) bookData['zoom'] = zoom;
      if (offset != null) {
        bookData['offsetX'] = offset.dx;
        bookData['offsetY'] = offset.dy;
      }
      dataJson[bookId] = bookData;
      _prefs.setString('books', jsonEncode(dataJson));
    }
  }
}

const bookMap = {
  "001": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "002": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "003": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "004": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "005": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "006": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "007": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "008": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "009": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "010": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "011": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "012": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "013": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "014": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "015": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "016": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
  "017": {"refreshedAt": "", "offsetX": 0, "offsetY": 0, "zoom": 1},
};
