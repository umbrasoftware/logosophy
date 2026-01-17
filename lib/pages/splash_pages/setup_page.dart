import 'dart:convert';
import 'dart:io';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/books/book_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/main.dart';
import 'package:logosophy/pages/splash_pages/animated_logo.dart';
import 'package:logosophy/pages/splash_pages/utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({super.key});

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

/// Enum to represent the different states of the setup process.
enum _SetupStatus { checking, needsDownload }

class _SetupPageState extends ConsumerState<SetupPage> {
  _SetupStatus _status = _SetupStatus.checking;
  final logger = Logger('SetupPage');
  bool aDownloadWasFinished = false;
  double _downloadProgress = 0.0;
  final String language = 'pt-BR';

  late Map<String, dynamic> mappings;
  late Directory langDir;

  @override
  void initState() {
    super.initState();
    _performChecksAndNavigate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _performChecksAndNavigate() async {
    logger.info("Performing checkings at the splash page.");

    await _checkAppDirectory();
    if (await langDir.list().isEmpty) {
      logger.info('No books found in any language.');
      if (mounted) setState(() => _status = _SetupStatus.needsDownload);
      return;
    } else {
      if (mounted) GoRouter.of(context).go('/books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  /// Builds the body of the page based on the current [_status].
  Widget _buildBody() {
    switch (_status) {
      case _SetupStatus.checking:
        return const Center(child: BreathingLogo());
      case _SetupStatus.needsDownload:
        return _buildLanguageSelectionBody();
    }
  }

  /// Builds the UI for when the user needs to select a language and download books.
  Widget _buildLanguageSelectionBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(t.setup.noBooks, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: _downloadProgress > 0 ? null : () => _downloadLanguageBooks(language),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CountryFlag.fromLanguageCode('pt-BR'),
                    const Text('Português'),
                    if (_downloadProgress > 0 && _downloadProgress < 1)
                      SizedBox(width: 24, height: 24, child: CircularProgressIndicator(value: _downloadProgress))
                    else if (_downloadProgress == 0)
                      const Icon(Icons.download)
                    else
                      const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: aDownloadWasFinished ? () => GoRouter.of(context).go('/books') : null,
              child: Text(t.btnActions.continueAction),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadLanguageBooks(String languageCode) async {
    setState(() {
      _downloadProgress = 0.0001;
    });

    try {
      await FilesUtils.downloadBooksForLanguage(languageCode, langDir, (progress) {
        setState(() => _downloadProgress = progress);
      });

      if (mounted) {
        ref.watch(bookProvider);
        setState(() {
          _downloadProgress = 1.0;
          aDownloadWasFinished = true;
        });
      }
    } catch (e) {
      logger.severe('Error downloading books: $e');
      if (mounted) {
        setState(() => _downloadProgress = 0.0);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _checkAppDirectory() async {
    final storage = supabase.client.storage;
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(appDocumentsDir.path, 'books'));
    if (!await booksDir.exists()) await booksDir.create(recursive: true);

    final mappingsFile = File(p.join(booksDir.path, 'mappings.json'));
    if (!await mappingsFile.exists()) {
      logger.info("mappings.json does not exists. Downloading...");
      final mappingsBytes = await storage.from('books').download('mapping.json');
      await mappingsFile.writeAsBytes(mappingsBytes);
    }

    final mappingsContent = await mappingsFile.readAsString();
    mappings = jsonDecode(mappingsContent) as Map<String, dynamic>;
    langDir = Directory(p.join(booksDir.path, language));
    if (!await langDir.exists()) {
      await langDir.create(recursive: true);
    }

    logger.info("Finished cheking app directory.");
  }
}
