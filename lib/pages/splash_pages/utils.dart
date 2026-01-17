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

  /// Given a language String, like 'pt-BR', goes to the books/language folder in
  /// Supabase Storage and downloads a zip file containing all PDF books and their cover images.
  static Future<void> downloadBooksForLanguage(
    String languageCode,
    Directory downloadDir,
    Function(double progress) onProgress,
  ) async {
    _logger.info('Downloading books for language: $languageCode');

    final url = await storage.from('books').createSignedUrl('$languageCode/books.zip', 600);
    final dio = Dio();
    final zipPath = join(downloadDir.path, 'books.zip');
    await dio.download(
      url,
      zipPath,
      onReceiveProgress: (received, total) {
        onProgress(received / total);
      },
    );

    final archive = ZipDecoder().decodeStream(InputFileStream(zipPath));
    await extractArchiveToDisk(archive, downloadDir.path);
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
