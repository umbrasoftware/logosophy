import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/books/book_status.dart';
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
          onViewerReady: (document, controller) async {
            if (widget.page != null) return;

            final position = BookReadStatus().getPosition(bookId);
            _pdfController.setZoom(position.offset, position.zoom);
            await BookReadStatus().saveTimestamp(bookId);
          },
          onInteractionEnd: (details) async {
            if (widget.page != null) return;

            final zoom = _pdfController.currentZoom;
            final offset = _pdfController.centerPosition;
            await BookReadStatus().savePosition(bookId, zoom, offset);
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
