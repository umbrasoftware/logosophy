import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/settings/settings_model.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

/// Provider responsible for holding the state of the app settings.
@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  final _logger = Logger('SettingsNotifier');
  late Box<Settings> _box;
  static const String _key = 'app_settings';

  @override
  Future<Settings> build() async {
    _box = await Hive.openBox<Settings>('settings');

    if (_box.isEmpty) {
      return _getDefaultConfigs();
    } else {
      return _getState();
    }
  }

  /// Get the default [Settings] config.
  Future<Settings> _getDefaultConfigs() async {
    final deviceLocale = LocaleSettings.useDeviceLocaleSync();
    final settings = Settings(language: deviceLocale.languageCode);

    await _box.put(_key, settings);
    return settings;
  }

  /// Get the state from the Hive box.
  Settings _getState() {
    final settings = _box.get(_key);
    if (settings == null) {
      _logger.shout("Settings from Hive is null despite data integrity passed.");
      return Settings(language: 'pt-BR');
    }

    return settings;
  }

  /// Changes the language in the provider and SharedPreferences.
  Future<void> changeLanguage(String language) async {
    final current = state.requireValue;
    final newSettings = current.copyWith(language: language);
    await LocaleSettings.setLocaleRaw(language);

    await _box.put(_key, newSettings);
    state = AsyncData(newSettings);
  }

  /// Changes the theme in the provider and SharedPreferences.
  Future<void> changeTheme(String theme) async {
    final current = state.requireValue;
    final newSettings = current.copyWith(theme: theme);

    await _box.put(_key, newSettings);
    state = AsyncData(newSettings);
  }
}
