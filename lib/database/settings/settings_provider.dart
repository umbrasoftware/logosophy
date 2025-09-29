import 'package:logging/logging.dart';
import 'package:logosophy/database/cache/settings_cache.dart';
import 'package:logosophy/database/settings/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  final _logger = Logger('SettingsNotifier');

  @override
  Settings build() {
    return SettingsCache().getConfig();
  }

  void changeLanguage(String language) {
    state = state.copyWith(language: language);
  }
}
