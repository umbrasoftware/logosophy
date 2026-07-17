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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(t.navBar.books)),
      body: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.7,
        ),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          return Card(
            key: ValueKey(book.bookId),
            elevation: 3.0,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.zero,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(book.coverPath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    _logger.severe('Error loading image: ${book.coverPath}', error, stackTrace);
                    return _buildCoverFallback(book, colorScheme);
                  },
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      GoRouter.of(context).push('/pdfviewer', extra: ReaderArgs(book.bookPath, page: null));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// A typographic cover shown when the cover image is missing.
  Widget _buildCoverFallback(BookData book, ColorScheme colorScheme) {
    return Container(
      color: colorScheme.primaryContainer,
      padding: const EdgeInsets.all(12.0),
      alignment: Alignment.center,
      child: Text(
        book.title,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onPrimaryContainer),
      ),
    );
  }
}
