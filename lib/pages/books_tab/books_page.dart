import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/books/book_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/pdf_reader.dart';
import 'package:logosophy/pages/splash_pages/animated_logo.dart';

class BooksPage extends ConsumerStatefulWidget {
  const BooksPage({super.key});

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {
  final logger = Logger('BooksPage');

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(bookProvider);
    if (provider.isLoading) {
      return const Center(child: BreathingLogo());
    }

    if (provider.hasError) {
      return const Center(child: Text("Error in book provider."));
    }

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
        itemCount: provider.requireValue.length,
        itemBuilder: (context, index) {
          final book = provider.requireValue[index];
          return InkWell(
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
                  logger.severe('Error loading image: ${book.coverPath}', error, stackTrace);
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
