import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FilesUtils {
  static final _logger = Logger('FilesUtils');

  /// Get the list of book folders (languages) in the 'books' directory.
  /// If the directory does not exist, returnan empty list.
  static Future<List<String>> getBooksFolders() async {
    _logger.info('Searching for books...');

    // Get application files directory
    final appDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(join(appDir.path, 'books'));
    if (!await booksDir.exists()) {
      await booksDir.create(recursive: true);
      _logger.info('Created books directory at: ${booksDir.path}');
      return [];
    } else {
      _logger.info('Books directory already exists at: ${booksDir.path}');

      List<String> languages = [];
      for (final folders in booksDir.listSync()) {
        if (folders is Directory) {
          languages.add(basename(folders.path));
        }
      }
      return languages;
    }
  }

  /// Given a language String, like 'pt-BR', goes to the books/language folder
  /// in Firestore and download all pdf books there.
  static Future<void> downloadBooksForLanguage(
    String languageCode, {
    void Function(int current, int total, String filename)? onBookProgress,
    void Function(double percentage)? onFileProgress,
  }) async {
    _logger.info('Downloading books for language: $languageCode');

    try {
      // Get the reference to the language folder in Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(
        "books/$languageCode",
      );
      final listResult = await storageRef.listAll();

      // Filter for PDF files only, ignoring case. This prevents downloading
      // other files like '.DS_Store' that might be in the storage bucket.
      final pdfItems = listResult.items
          .where((item) => item.name.toLowerCase().endsWith('.pdf'))
          .toList();

      final totalFiles = pdfItems.length;
      var currentFile = 0;

      // Get the local directory to save the books
      final appDir = await getApplicationDocumentsDirectory();
      final langDir = Directory(join(appDir.path, 'books', languageCode));
      await langDir.create(recursive: true);

      for (final item in pdfItems) {
        currentFile++;
        onBookProgress?.call(currentFile, totalFiles, item.name);

        _logger.info('Downloading ${item.name}...');
        final localFile = File(join(langDir.path, item.name));

        // Download the file from Firebase Storage to the local file system.
        final downloadTask = item.writeToFile(localFile);

        // Listen to the download task to get progress updates for the current file.
        downloadTask.snapshotEvents.listen((taskSnapshot) {
          final progress =
              taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
          onFileProgress?.call(progress);
        });

        await downloadTask; // Wait for the download to complete.
        _logger.info(
          'Successfully downloaded ${item.name} to ${localFile.path}',
        );
      }
    } on FirebaseException catch (e) {
      _logger.severe('Error downloading books for $languageCode: $e');
    }
  }

  /// Deletes all downloaded books and their containing folders.
  /// Useful for testing the download process from a clean state.
  static Future<void> deleteDownloadedBooks() async {
    _logger.info('Deleting all downloaded books...');
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final booksDir = Directory(join(appDir.path, 'books'));

      if (await booksDir.exists()) {
        await booksDir.delete(recursive: true);
        _logger.info('Successfully deleted books directory: ${booksDir.path}');
      } else {
        _logger.info('Books directory does not exist. Nothing to delete.');
      }
    } catch (e) {
      _logger.severe('Error deleting downloaded books: $e');
    }
  }
}
