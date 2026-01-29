import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/settings/settings_model.dart';
import 'package:logosophy/database/settings/settings_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/settings_tab/utils.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _logger = Logger('SettingsPage');
  late Settings _settings;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    return settingsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) {
        _logger.shout("$err, $stack");
        return Scaffold(
          body: Center(
            child: Text(err.toString(), style: TextStyle(color: Colors.red)),
          ),
        );
      },
      data: (settingsData) {
        _settings = settingsData;
        return _buildBody();
      },
    );
  }

  /// Build the main body.
  Scaffold _buildBody() {
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

  // Method to change the locale and update the UI
  Future<void> _changeLocale(BuildContext context, String locale) async {
    await ref.read(settingsProvider.notifier).changeLanguage(locale);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
