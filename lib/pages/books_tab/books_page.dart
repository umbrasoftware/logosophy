import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/app_utils.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/pdf_reader.dart';
import 'package:logosophy/providers/books/book_model.dart';
import 'package:logosophy/providers/books/book_provider.dart';

class BooksPage extends ConsumerStatefulWidget {
  const BooksPage({super.key});

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {
  final _logger = Logger('BooksPage');
  late List<BookData> _books;

  @override
  Widget build(BuildContext context) {
    TranslationProvider.of(context);
    final bookAsync = ref.watch(bookProvider);

    final loadingScreen = AppUtils.buildLoadingPage([bookAsync]);
    if (loadingScreen != null) return loadingScreen;

    final errorScreen = AppUtils.buildErrorPage([bookAsync]);
    if (errorScreen != null) return errorScreen;

    _books = bookAsync.requireValue;
    return Scaffold(
      appBar: AppBar(title: Text(t.navBar.books)),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7,
        ),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return InkWell(
            key: ValueKey(book.bookId),
            onTap: () {
              GoRouter.of(context).push('/pdfviewer', extra: ReaderArgs(book.bookPath, page: null));
            },
            child: Card(
              elevation: 2.0,
              clipBehavior: Clip.antiAlias,
              child: Image.file(
                File(book.coverPath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  _logger.severe('Error loading image: ${book.coverPath}', error, stackTrace);
                  return const Center(child: Icon(Icons.broken_image, size: 40));
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
