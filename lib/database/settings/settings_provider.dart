import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/settings/settings_model.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

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
    if (!_isDataIntegrityOk()) return Settings(language: 'pt-BR');

    final settings = _box.get(_key);
    if (settings == null) {
      _logger.shout("Settings from Hive is null despite data integrity passed.");
      return Settings(language: 'pt-BR');
    }

    return settings;
  }

  /// Changes the language in the provider and SharedPreferences.
  Future<void> changeLanguage(String language) async {
    if (!_isDataIntegrityOk()) return;

    final current = state.requireValue;
    final newSettings = current.copyWith(language: language);
    await LocaleSettings.setLocaleRaw(language);

    await _box.put(_key, newSettings);
    state = AsyncData(newSettings);
  }

  /// Changes the theme in the provider and SharedPreferences.
  Future<void> changeTheme(String theme) async {
    if (!_isDataIntegrityOk()) return;

    final current = state.requireValue;
    final newSettings = current.copyWith(theme: theme);

    await _box.put(_key, newSettings);
    state = AsyncData(newSettings);
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
