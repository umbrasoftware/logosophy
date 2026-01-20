import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/settings/settings_provider.dart';
import 'package:logosophy/gen/strings.g.dart';

class SettingsUtils {
  static String getLocaleName(WidgetRef ref) {
    switch (ref.watch(settingsProvider).requireValue.language) {
      case 'pt-BR':
        return t.settingsPage.portuguese;
      case 'en':
        return t.settingsPage.english;
      default:
        return 'Unknown';
    }
  }

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

  static ThemeMode getThemeMode(WidgetRef ref) {
    return switch (ref.watch(settingsProvider).requireValue.theme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
