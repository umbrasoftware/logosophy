import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logosophy/app_utils.dart';
import 'package:logosophy/providers/settings/settings_model.dart';
import 'package:logosophy/providers/settings/settings_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/settings_tab/utils.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  late Settings _settings;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    final loadingPage = AppUtils.buildLoadingPage([settingsAsync]);
    if (loadingPage != null) return loadingPage;

    final errorPage = AppUtils.buildErrorPage([settingsAsync]);
    if (errorPage != null) return errorPage;

    _settings = settingsAsync.requireValue;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsPage.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            color: colorScheme.surfaceContainer,
            child: ListTile(
              textColor: colorScheme.onSurface,
              iconColor: colorScheme.onSurface,
              leading: const Icon(Icons.language),
              title: Text(t.settingsPage.language),
              subtitle: Text(SettingsUtils.getLocaleName(ref), style: TextStyle(color: colorScheme.onSurfaceVariant)),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.onSurfaceVariant),
              onTap: _showLanguageDialog,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: colorScheme.surfaceContainer,
            child: ListTile(
              textColor: colorScheme.onSurface,
              iconColor: colorScheme.onSurface,
              leading: const Icon(Icons.brightness_4),
              title: Text(t.settingsPage.theme),
              subtitle: Text(SettingsUtils.getThemeName(ref), style: TextStyle(color: colorScheme.onSurfaceVariant)),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.onSurfaceVariant),
              onTap: _showThemeDialog,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: colorScheme.surfaceContainer,
            child: ListTile(
              textColor: colorScheme.onSurface,
              iconColor: colorScheme.onSurface,
              leading: const Icon(Icons.font_download),
              title: Text(t.settingsPage.fontSize),
              subtitle: Text(t.settingsPage.changeFontSize, style: TextStyle(color: colorScheme.onSurfaceVariant)),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.onSurfaceVariant),
              onTap: _showFontSizeDialog,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: colorScheme.surfaceContainer,
            child: ListTile(
              textColor: colorScheme.onSurface,
              iconColor: colorScheme.onSurface,
              leading: const Icon(Icons.contact_support),
              title: Text(t.feedbackPage.contactUs),
              subtitle: Text(t.feedbackPage.desc, style: TextStyle(color: colorScheme.onSurfaceVariant)),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.onSurfaceVariant),
              onTap: () => GoRouter.of(context).push('/support'),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows the Language Dialog.
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.settingsPage.selectLanguage),
          content: RadioGroup<String>(
            groupValue: _settings.language,
            onChanged: (String? value) async {
              if (value != null) {
                await _changeLocale(context, value);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(title: Text(t.settingsPage.portuguese), value: 'pt-BR'),
                RadioListTile<String>(title: Text(t.settingsPage.english), value: 'en'),
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

  /// Shows the Theme Dialog.
  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.settingsPage.selectTheme),
        content: RadioGroup<String>(
          groupValue: _settings.theme,
          onChanged: (String? value) async {
            if (value != null) {
              await ref.read(settingsProvider.notifier).changeTheme(value);

              if (context.mounted) Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(title: Text(t.settingsPage.light), value: 'light'),
              RadioListTile<String>(title: Text(t.settingsPage.dark), value: 'dark'),
              RadioListTile<String>(title: Text(t.settingsPage.system), value: 'system'),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows the Font Size Dialog.
  void _showFontSizeDialog() {
    final colorScheme = Theme.of(context).colorScheme;
    double fontSize = _settings.fontSize;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(t.settingsPage.changeFontSize),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.settingsPage.bookTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16 + fontSize,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          t.bookPage.page(page: 1),
                          style: TextStyle(fontSize: 12 + fontSize, color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceDim,
                            borderRadius: BorderRadius.circular(6.0),
                            border: Border.all(color: colorScheme.outlineVariant),
                          ),
                          child: Text(
                            t.settingsPage.fontBookSnippet,
                            style: TextStyle(
                              fontSize: 13 + fontSize,
                              color: colorScheme.onSurface,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: fontSize,
                      min: -2.0,
                      max: 12.0,
                      divisions: 14,
                      label: fontSize.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          fontSize = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(t.btnActions.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(t.btnActions.save),
                  onPressed: () async {
                    await ref.read(settingsProvider.notifier).changeFontSize(fontSize);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Method to change the locale and update the UI
  Future<void> _changeLocale(BuildContext context, String locale) async {
    await ref.read(settingsProvider.notifier).changeLanguage(locale);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
