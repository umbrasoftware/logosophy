import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnotationsCache {
  AnnotationsCache._internal();
  static final AnnotationsCache _instance = AnnotationsCache._internal();
  factory AnnotationsCache() => _instance;

  static const int updateTimeMin = 180;

  final _logger = Logger('AnnotationsCache');
  late SharedPreferencesWithCache _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

    if (_prefs.getString('annotations') == null) {
      await _prefs.setString('annotations', "");
    }
  }

  void update() {
    _prefs.setString('annotations', DateTime.now().toIso8601String());
  }

  bool isFresh() {
    final lastUpdate = _prefs.getString('annotations');
    if (lastUpdate != null && lastUpdate.isNotEmpty) {
      final lastUpdateDateTime = DateTime.parse(lastUpdate);
      final now = DateTime.now();
      final diff = now.difference(lastUpdateDateTime);
      final isFresh = diff.inMinutes < updateTimeMin;
      _logger.info('Annotations is ${isFresh ? '' : 'not '}fresh');
      return isFresh;
    }
    _logger.info('Annotations is not fresh');
    return false;
  }
}
