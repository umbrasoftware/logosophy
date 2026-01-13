import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:logosophy/database/settings/settings_model.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  final _logger = Logger('SettingsNotifier');
  static const String prefsName = 'settings';
  late SharedPreferencesWithCache _prefs;

  @override
  Settings build() {
    return Settings.fromJson({});
  }

  /// Initializes the provider. Must be called before everything else.
  Future<void> init() async {
    try {
      _prefs = await SharedPreferencesWithCache.create(cacheOptions: const SharedPreferencesWithCacheOptions());
      final diskData = _prefs.getString(prefsName);

      if (diskData == null) {
        final defaultConfig = _getDefaultConfigs();
        await _prefs.setString(prefsName, json.encode(defaultConfig));
        state = Settings.fromJson(defaultConfig);
      } else {
        final decoded = json.decode(diskData);
        state = Settings.fromJson(decoded);
      }
    } catch (e, st) {
      _logger.severe("ERROR in SettingsNotifier.init(): $e");
      _logger.severe("StackTrace: $st");
      rethrow;
    }
  }

  /// Changes the language in the provider and SharedPreferences.
  Future<void> changeLanguage(String language) async {
    final settings = _prefs.getString(prefsName);
    if (settings == null) {
      _logger.shout("Prefs on disk is null while trying to change language.");
      return;
    }

    final jsonData = json.decode(settings);
    jsonData["language"] = language;
    await _prefs.setString(prefsName, json.encode(jsonData));
    await LocaleSettings.setLocaleRaw(language);

    state = state.copyWith(language: language);
  }

  /// Changes the theme in the provider and SharedPreferences.
  Future<void> changeTheme(String theme) async {
    final settings = _prefs.getString(prefsName);
    if (settings == null) {
      _logger.shout("Prefs on disk is null while trying to change theme.");
      return;
    }

    final jsonObj = json.decode(settings);
    jsonObj["theme"] = theme;
    await _prefs.setString(prefsName, json.encode(jsonObj));

    state = state.copyWith(theme: theme);
  }

  /// Get the default configuration. Locale is get by what is being used in the device.
  Map<String, dynamic> _getDefaultConfigs() {
    final deviceLocale = LocaleSettings.useDeviceLocaleSync();
    final settings = {"language": deviceLocale.languageCode, "theme": 'system', "overrideBookState": false};

    return settings;
  }
}
