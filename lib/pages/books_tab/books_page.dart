import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/settings/settings_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/pdf_reader.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A simple data class to hold book information for sorting and display.
class _BookData {
  final File coverFile;
  final String title;

  _BookData({required this.coverFile, required this.title});
}

class BooksPage extends ConsumerStatefulWidget {
  const BooksPage({super.key});

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {
  final logger = Logger('BooksPage');
  late String language;

  @override
  void initState() {
    language = ref.read(settingsProvider).language;
    super.initState();
  }

  Future<List<_BookData>> _getBooksData() async {
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final booksDir = Directory(p.join(appDocumentsDir.path, 'books'));
    final mappingsFile = File(p.join(booksDir.path, 'mappings.json'));
    List<_BookData> booksData = [];

    if (!await mappingsFile.exists()) {
      logger.severe('mappings.json not found at ${mappingsFile.path}');
      return [];
    }

    final mappingsContent = await mappingsFile.readAsString();
    final mappings = jsonDecode(mappingsContent) as Map<String, dynamic>;

    final langDir = Directory(p.join(booksDir.path, 'pt-BR'));

    if (await langDir.exists()) {
      final entities = langDir.listSync();
      for (var entity in entities) {
        if (entity is File) {
          final fileName = p.basename(entity.path);
          const coverSuffix = '_cover.png';
          if (fileName.endsWith(coverSuffix)) {
            final baseName = fileName.substring(0, fileName.length - coverSuffix.length);
            final pdfFileName = '$baseName.pdf';
            final bookInfo = mappings['pt-BR']?[pdfFileName];

            if (bookInfo != null && bookInfo['title'] != null) {
              booksData.add(_BookData(coverFile: entity, title: bookInfo['title']));
            } else {
              logger.warning('No mapping found for $pdfFileName in pt-BR');
            }
          }
        }
      }
    } else {
      logger.warning('Language directory not found: ${langDir.path}');
    }

    return booksData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.navBar.books)),
      body: FutureBuilder<List<_BookData>>(
        future: _getBooksData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading book covers: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No books found'));
          }

          final books = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final bookData = books[index];
              return InkWell(
                onTap: () {
                  const coverSuffix = '_cover.png';
                  final coverPath = bookData.coverFile.path;
                  final pdfPath = '${coverPath.substring(0, coverPath.length - coverSuffix.length)}.pdf';
                  GoRouter.of(context).push('/pdfviewer', extra: ReaderArgs(pdfPath, page: null));
                },
                child: Card(
                  elevation: 2.0,
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(
                    bookData.coverFile,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      logger.severe('Error loading image: ${bookData.coverFile.path}', error, stackTrace);
                      return const Center(child: Icon(Icons.broken_image, size: 40));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
