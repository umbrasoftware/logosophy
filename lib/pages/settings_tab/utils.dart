import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/providers/settings/settings_provider.dart';
import 'package:logosophy/gen/strings.g.dart';

class SettingsUtils {
  /// Get the locale code.
  static String getLocaleName(WidgetRef ref) {
    final provider = ref.watch(settingsProvider);
    if (provider.isLoading || provider.hasError) return t.settingsPage.portuguese;

    switch (provider.requireValue.language) {
      case 'pt-BR':
        return t.settingsPage.portuguese;
      case 'en':
        return t.settingsPage.english;
      default:
        return 'Unknown';
    }
  }

  /// Get the theme name: Ex: light, dark, system.
  static String getThemeName(WidgetRef ref) {
    switch (ref.read(settingsProvider).requireValue.theme) {
      case 'light':
        return t.settingsPage.light;
      case 'dark':
        return t.settingsPage.dark;
      default:
        return t.settingsPage.system;
    }
  }

  /// Get's the [ThemeMode] from the Provider. If not available,
  /// returns [ThemeData.system] instead.
  static ThemeMode getThemeMode(WidgetRef ref) {
    final provider = ref.watch(settingsProvider);
    if (provider.isLoading || provider.hasError) return ThemeMode.system;

    return switch (provider.requireValue.theme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
