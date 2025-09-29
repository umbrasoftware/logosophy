import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:logosophy/database/settings/models/settings.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCache {
  SettingsCache._internal();
  static final SettingsCache _instance = SettingsCache._internal();
  factory SettingsCache() => _instance;

  final _logger = Logger('SettingsCache');
  late SharedPreferencesWithCache _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );

    if (_prefs.getString('settings') == null) {
      await _prefs.setString('settings', json.encode(getDefaultConfigs()));
    }
  }

  Settings getConfig() {
    final settings = json.decode(_prefs.getString('settings')!);
    return Settings(language: settings['language']);
  }

  String getLocale() {
    final settings = json.decode(_prefs.getString('settings')!);
    return settings['language'];
  }

  Map<String, dynamic> getDefaultConfigs() {
    final deviceLocale = LocaleSettings.useDeviceLocaleSync();
    final settings = {"language": deviceLocale.languageCode};

    return settings;
  }

  void saveLanguage(String language) {
    final settings = json.decode(_prefs.getString('settings')!);
    settings['language'] = language;
    _prefs.setString('settings', json.encode(settings));
    _logger.info('Language saved: $language');
  }
}
