import 'dart:convert';
import 'dart:io';

import 'package:country_flags/country_flags.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/splash_pages/animated_logo.dart';
import 'package:logosophy/utils/auth_utils.dart';
import 'package:logosophy/utils/files_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class SetupPage extends ConsumerStatefulWidget {
  const SetupPage({super.key});

  @override
  ConsumerState<SetupPage> createState() => _SetupPageState();
}

/// Enum to represent the different states of the setup process.
enum _SetupStatus { checking, needsDownload, complete }

class _SetupPageState extends ConsumerState<SetupPage> {
  _SetupStatus _status = _SetupStatus.checking;
  final logger = Logger('SetupPage');
  late Map<String, dynamic> mappings;

  @override
  void initState() {
    super.initState();
    _performChecksAndNavigate();
  }

  Future<void> _performChecksAndNavigate() async {
    // await FilesUtils.deleteDownloadedBooks(); // For testing purposes

    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    final appDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(appDir.path, 'books'));
    final mappingsFile = File(p.join(booksDir.path, 'mappings.json'));
    if (!await mappingsFile.exists()) {
      logger.info("mappings.json does not exists. Downloading...");
      // Ensure the parent directory exists before trying to write the file.
      // `writeToFile` will create the file itself.
      await booksDir.create(recursive: true);
      await storageRef.child('books/mapping.json').writeToFile(mappingsFile);
    }

    // Loads the mapping.json to a actual dart Map file
    final content = await mappingsFile.readAsString();
    mappings = jsonDecode(content);

    final languages = await FilesUtils.getBooksFolders();
    if (languages.isEmpty) {
      logger.info('No books found in any language.');
      if (mounted) setState(() => _status = _SetupStatus.needsDownload);
      return;
    }

    // If checks are complete and books exist, update state and navigate.
    if (mounted) setState(() => _status = _SetupStatus.complete);

    if (mounted) {
      await AuthUtils().loadDocuments(ref);
      // ignore: use_build_context_synchronously
      GoRouter.of(context).go('/home');
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
      case _SetupStatus.complete:
        return const Center(child: BreathingLogo());
      case _SetupStatus.needsDownload:
        return _buildLanguageSelectionBody(mappings);
    }
  }

  /// Builds the UI for when the user needs to select a language and download books.
  Widget _buildLanguageSelectionBody(Map<String, dynamic> mappings) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.setup.noBooks,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () async {
                // Show the progress dialog and wait for it to be popped.
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => _DownloadProgressDialog(
                    languageCode: 'pt-BR',
                    mappings: mappings,
                  ),
                );

                // After the dialog is closed (download complete), navigate.
                if (mounted) {
                  GoRouter.of(context).go('/home');
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Português'),
                  const SizedBox(width: 8),
                  CountryFlag.fromLanguageCode('pt-BR', shape: Circle()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A dialog that shows the progress of book downloads.
class _DownloadProgressDialog extends StatefulWidget {
  final String languageCode;
  final Map<String, dynamic> mappings;

  const _DownloadProgressDialog({
    required this.languageCode,
    required this.mappings,
  });

  @override
  State<_DownloadProgressDialog> createState() =>
      _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<_DownloadProgressDialog> {
  String _progressMessage = t.setup.starting;
  double _fileProgress = 0.0;
  bool _isDownloadComplete = false;

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  Future<void> _startDownload() async {
    await FilesUtils.downloadBooksForLanguage(
      widget.languageCode,
      onBookProgress: (current, total, filename) {
        if (mounted) {
          setState(() {
            // Use the internationalized string for the progress message.
            _progressMessage = t.setup.downloadProgress(
              filename: widget.mappings[widget.languageCode][filename]['title'],
              current: current,
              total: total,
            );
            _fileProgress = 0.0; // Reset for new file
          });
        }
      },
      onFileProgress: (percentage) {
        if (mounted) {
          // Clamp the value between 0.0 and 1.0 to prevent any potential
          // floating point inaccuracies or negative values like the '-0' you saw.
          setState(() => _fileProgress = percentage.clamp(0.0, 1.0));
        }
      },
    );

    // When download is complete, update the state to show the continue button.
    if (mounted) {
      setState(() {
        _isDownloadComplete = true;
        _progressMessage = t.setup.downloadComplete;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // To prevent the dialog from resizing horizontally, we give its content
    // a fixed width based on the screen size.
    final dialogWidth = MediaQuery.of(context).size.width * 0.75;

    return AlertDialog(
      title: Text(t.setup.downloadingBooks),
      content: SizedBox(
        width: dialogWidth,
        child: _isDownloadComplete
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _progressMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // To prevent the dialog from resizing vertically when the
                  // filename changes, we use a SizedBox with a fixed height.
                  SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        _progressMessage,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: _fileProgress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 8),
                  Text('${(_fileProgress * 100).toStringAsFixed(0)}%'),
                ],
              ),
      ),
      actions: _isDownloadComplete
          ? [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(t.btnActions.continueAction),
              ),
            ]
          : null,
    );
  }
}
