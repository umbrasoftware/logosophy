import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesCache {
  NotesCache._internal();
  static final NotesCache _instance = NotesCache._internal();
  factory NotesCache() => _instance;

  static const int updateTimeMin = 180;

  final _logger = Logger('NotesCache');
  late SharedPreferencesWithCache _prefs;

  void init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

    if (_prefs.getString('notes') == null) {
      await _prefs.setString('notes', "");
    }
  }

  void update() {
    _prefs.setString('notes', DateTime.now().toIso8601String());
  }

  bool isFresh() {
    final lastUpdate = _prefs.getString('notes');
    if (lastUpdate != null && lastUpdate.isNotEmpty) {
      final lastUpdateDateTime = DateTime.parse(lastUpdate);
      final now = DateTime.now();
      final diff = now.difference(lastUpdateDateTime);
      final isFresh = diff.inMinutes < updateTimeMin;
      _logger.info('Notes is ${isFresh ? '' : 'not '}fresh');
      return isFresh;
    }
    _logger.info('Notes is not fresh');
    return false;
  }
}
