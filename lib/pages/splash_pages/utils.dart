import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FilesUtils {
  static final _logger = Logger('FilesUtils');
  static final storage = supabase.client.storage;

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

  /// Given a language String, like 'pt-BR', goes to the books/language folder in
  /// Firestore and downloads all PDF books and their cover images (files ending
  /// in `_cover.png`).
  static Future<void> downloadBooksForLanguage(String languageCode, Function(double progress) onProgress) async {
    _logger.info('Downloading books for language: $languageCode');

    final appDir = await getApplicationDocumentsDirectory();
    final langDir = Directory(join(appDir.path, 'books', languageCode));
    await langDir.create(recursive: true);
    final url = await storage.from('books').createSignedUrl('$languageCode/books.zip', 180);
    _logger.info('Download URL: $url');

    final dio = Dio();
    final zipPath = join(langDir.path, 'books.zip');
    await dio.download(
      url,
      zipPath,
      onReceiveProgress: (received, total) {
        onProgress(received / total);
      },
    );

    final archive = ZipDecoder().decodeStream(InputFileStream(zipPath));
    await extractArchiveToDisk(archive, langDir.path);
    await File(zipPath).delete();
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
