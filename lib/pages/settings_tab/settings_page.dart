import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/cache/settings_cache.dart';
import 'package:logosophy/database/settings/settings_provider.dart';
import 'package:logosophy/gen/strings.g.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late String _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = ref.read(settingsNotifierProvider).language;
  }

  // Helper method to get the display name for a locale
  String _getLocaleName(String locale) {
    switch (locale) {
      case 'pt-BR':
        return t.settingsPage.portuguese;
      case 'en':
        return t.settingsPage.english;
      default:
        return '';
    }
  }

  // Method to show the language selection dialog
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.settingsPage.selectLanguage),
          content: RadioGroup<String>(
            groupValue: _currentLocale,
            onChanged: (String? value) async {
              if (value != null) {
                await _changeLocale(context, value);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text(t.settingsPage.portuguese),
                  value: 'pt-BR',
                ),
                RadioListTile<String>(
                  title: Text(t.settingsPage.english),
                  value: 'en',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(t.btnActions.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Method to change the locale and update the UI
  Future<void> _changeLocale(BuildContext context, String locale) async {
    setState(() {
      _currentLocale = locale;
      ref.read(settingsNotifierProvider.notifier).changeLanguage(locale);
    });
    SettingsCache().saveLanguage(locale);
    await LocaleSettings.setLocaleRaw(locale);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.settingsPage.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(t.settingsPage.language),
              subtitle: Text(_getLocaleName(_currentLocale)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showLanguageDialog,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: Text(t.settingsPage.signOut),
          ),
        ],
      ),
    );
  }
}
