import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/books/book_data.dart';
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

  @override
  void initState() {
    bookId = widget.filePath.split('/').last.replaceFirst(".pdf", "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfViewer.file(
        widget.filePath,
        initialPageNumber: widget.page ?? 1,
        controller: _pdfController,
        params: PdfViewerParams(
          onViewerReady: (document, controller) {
            final position = BookData().getPosition(bookId);
            _pdfController.setZoom(position.offset, position.zoom);
          },
          onInteractionEnd: (details) async {
            final zoom = _pdfController.currentZoom;
            final offset = _pdfController.centerPosition;
            await BookData().savePosition(bookId, zoom, offset);
            logger.info("Book position saved: zoom: $zoom, offset:  $offset");
          },
        ),
      ),
    );
  }
}

class ReaderArgs {
  ReaderArgs(this.path, {this.page});

  final String path;
  final int? page;
}
