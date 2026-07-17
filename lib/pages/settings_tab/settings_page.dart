import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logosophy/app_utils.dart';
import 'package:logosophy/providers/settings/settings_model.dart';
import 'package:logosophy/providers/settings/settings_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/settings_tab/utils.dart';
import 'package:logosophy/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSettingTile(
                  icon: Icons.translate,
                  title: t.settingsPage.language,
                  subtitle: SettingsUtils.getLocaleName(ref),
                  onTap: _showLanguageDialog,
                ),
                const SizedBox(height: 12),
                _buildSettingTile(
                  icon: Icons.brightness_6_outlined,
                  title: t.settingsPage.theme,
                  subtitle: SettingsUtils.getThemeName(ref),
                  onTap: _showThemeDialog,
                ),
                const SizedBox(height: 12),
                _buildSettingTile(
                  icon: Icons.format_size,
                  title: t.settingsPage.fontSize,
                  subtitle: t.settingsPage.changeFontSize,
                  onTap: _showFontSizeDialog,
                ),
                const SizedBox(height: 12),
                _buildSettingTile(
                  icon: Icons.support_agent,
                  title: t.feedbackPage.contactUs,
                  subtitle: t.feedbackPage.desc,
                  onTap: () => GoRouter.of(context).push('/support'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Text(
                    "Logosofia · v${data.version}+${data.buildNumber}",
                    style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 11),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// A settings card in the Aurora style: tinted icon circle, title,
  /// current value as subtitle, chevron affordance.
  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.surfaceContainer,
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: Icon(icon, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: colorScheme.onSurfaceVariant)),
        trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
        onTap: onTap,
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
                    _buildFontPreview(colorScheme, fontSize),
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

  /// Builds the book title/page badge/passage preview shown in the font size dialog.
  Widget _buildFontPreview(ColorScheme colorScheme, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                t.settingsPage.bookTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 + fontSize, color: colorScheme.onSurface),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
              decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(999)),
              child: Text(
                t.bookPage.page(page: 1),
                style: TextStyle(
                  fontSize: 11 + fontSize,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: colorScheme.primary, width: 2)),
          ),
          child: Text(
            t.settingsPage.fontBookSnippet,
            style: AuroraTheme.passage(fontSize: 13 + fontSize, color: colorScheme.onSurface),
          ),
        ),
      ],
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
