import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/books/book_provider.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';
import 'package:logging/logging.dart';

class PDFReader extends ConsumerStatefulWidget {
  const PDFReader({super.key, required this.filePath, this.page});

  final String filePath;
  final int? page;

  @override
  ConsumerState<PDFReader> createState() => _PdfViewerState();
}

class _PdfViewerState extends ConsumerState<PDFReader> {
  final logger = Logger('PDF Viewer');

  bool isDocumentLoaded = false;
  late String bookId;
  final _pdfController = PdfViewerController();
  PdfTextSearcher? _textSearcher;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  bool _isSearchActive = false;

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    final fileName = p.basename(widget.filePath);
    bookId = fileName.split(".")[0];
    super.initState();
  }

  @override
  void dispose() {
    _textSearcher?.removeListener(_update);
    _textSearcher?.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: PdfViewer.file(
        widget.filePath,
        initialPageNumber: widget.page ?? 1,
        controller: _pdfController,
        params: PdfViewerParams(
          pagePaintCallbacks: [if (_textSearcher != null) _textSearcher!.pageTextMatchPaintCallback],
          onViewerReady: (document, controller) async {
            if (_textSearcher == null) {
              _textSearcher = PdfTextSearcher(controller)..addListener(_update);
              if (mounted) setState(() {});
            }

            if (widget.page != null) return;

            final bookNotifier = ref.read(bookProvider.notifier);
            final position = bookNotifier.getPosition(bookId);
            if (position == null) return;

            _pdfController.setZoom(Offset(position.x, position.y), position.zoom, duration: Duration.zero);
            await bookNotifier.saveTimestamp(bookId);
          },
          onInteractionEnd: (details) async {
            if (widget.page != null) return;

            final zoom = _pdfController.currentZoom;
            final offset = _pdfController.centerPosition;
            await ref.read(bookProvider.notifier).savePosition(bookId, zoom, offset);
          },
          scrollPhysics: const FixedOverscrollPhysics(maxOverscroll: 100),
          scrollPhysicsScale: const BouncingScrollPhysics(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isSearchActive && _textSearcher != null) {
      final textSearcher = _textSearcher!;
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isSearchActive = false;
              textSearcher.resetTextSearch();
              _searchController.clear();
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(hintText: t.searchPage.search, border: InputBorder.none),
          onSubmitted: (value) {
            textSearcher.startTextSearch(value, caseInsensitive: true);
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              textSearcher.startTextSearch(value, caseInsensitive: true);
            } else {
              textSearcher.resetTextSearch();
            }
          },
        ),
        actions: [
          Center(
            child: Text(
              textSearcher.matches.isEmpty
                  ? '0/0'
                  : '${(textSearcher.currentIndex ?? -1) + 1}/${textSearcher.matches.length}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up),
            onPressed: (textSearcher.currentIndex != null && textSearcher.currentIndex! > 0)
                ? () {
                    textSearcher.goToPrevMatch();
                    _update();
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            onPressed:
                (textSearcher.matches.isNotEmpty &&
                    (textSearcher.currentIndex == null || textSearcher.currentIndex! < textSearcher.matches.length - 1))
                ? () {
                    textSearcher.goToNextMatch();
                    _update();
                  }
                : null,
          ),
        ],
      );
    }

    return AppBar(
      actions: [
        if (_textSearcher != null)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() => _isSearchActive = true);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _searchFocusNode.requestFocus();
              });
            },
          ),
      ],
    );
  }
}

class ReaderArgs {
  ReaderArgs(this.path, {this.page});

  final String path;
  final int? page;
}
