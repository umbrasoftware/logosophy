import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/annotations/annotations_provider.dart';
import 'package:logosophy/database/cache/book_cache.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/overlays/notes_overlay.dart';
import 'package:logosophy/utils/pdf_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'overlays/annotations_overlay.dart';
import 'overlays/searchbar_overlay.dart';

class PdfViewer extends ConsumerStatefulWidget {
  const PdfViewer({super.key, required this.file, this.page});

  final File file;
  final int? page;

  @override
  ConsumerState<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends ConsumerState<PdfViewer> {
  final logger = Logger('PDF Viewer');

  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final _annotationsOverlayBucket = PageStorageBucket();
  final _notesOverlayBucket = PageStorageBucket();
  OverlayEntry? _overlayEntry;
  OverlayEntry? _annotationsOverlay;
  OverlayEntry? _notesOverlay;
  late bool _showToolbar;
  late bool _showScrollHead;
  bool isDocumentLoaded = false;
  late String bookId;
  late AnnotationsNotifier annoProvider;

  LocalHistoryEntry? _historyEntry;

  @override
  void initState() {
    bookId = widget.file.path.split('/').last.split('.').first;
    _showToolbar = false;
    _showScrollHead = true;
    annoProvider = ref.read(annotationsNotifierProvider.notifier);
    super.initState();
  }

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
      }
    }
  }

  void _hideAnnotationsOverlay() {
    _annotationsOverlay?.remove();
    _annotationsOverlay = null;
  }

  void _hideNotesOverlay() {
    _notesOverlay?.remove();
    _notesOverlay = null;
  }

  void _handleHistoryEntryRemoved() {
    _textSearchKey.currentState?.clearSearch();
    setState(() {
      _showToolbar = false;
    });
    _historyEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showToolbar ? buildSearchToolbar(context) : buildAppBar(),
      body: Stack(
        children: [
          SfPdfViewer.file(
            key: _pdfViewerKey,
            widget.file,
            controller: _pdfViewerController,
            canShowTextSelectionMenu: false,
            canShowScrollHead: _showScrollHead,
            onDocumentLoaded: (details) async {
              if (widget.page != null) {
                _pdfViewerController.jumpToPage(widget.page!);
              } else {
                final position = BookCache().getPosition(bookId);
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (mounted) {
                    _pdfViewerController.zoomLevel = position.zoom;
                    _pdfViewerController.jumpTo(
                      xOffset: position.offset.dx,
                      yOffset: position.offset.dy,
                    );
                  }
                  isDocumentLoaded = true;
                });
              }

              final selections = annoProvider.getSelectionSpans(bookId);
              PDFUtils.applySelections(_pdfViewerController, selections);
            },
            onPageChanged: (_) {
              if (isDocumentLoaded) {
                PDFUtils.savePosition(bookId, _pdfViewerController);
              }
            },
            onZoomLevelChanged: (_) {
              if (isDocumentLoaded) {
                PDFUtils.savePosition(bookId, _pdfViewerController);
              }
            },
            onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
              if (details.selectedText == null && _overlayEntry != null) {
                _overlayEntry!.remove();
                _overlayEntry = null;
              } else if (details.selectedText != null &&
                  _overlayEntry == null) {
                final lines = _pdfViewerKey.currentState
                    ?.getSelectedTextLines();
                _showContextMenu(context, details, lines);
              }
            },
          ),
          buildSearchVisibility(),
        ],
      ),
    );
  }

  Visibility buildSearchVisibility() {
    return Visibility(
      visible: _textSearchKey.currentState?.showToast ?? false,
      child: Align(
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, top: 7, right: 15, bottom: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Text(
                t.bookPage.noResult,
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.note_add_sharp),
          onPressed: _showNotesOverlay,
        ),
        IconButton(
          icon: Icon(Icons.bookmark),
          onPressed: _showAnnotationsOverlay,
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            setState(() {
              _showScrollHead = false;
              _showToolbar = true;
              _ensureHistoryEntry();
            });
          },
        ),
      ],
      automaticallyImplyLeading: false,
    );
  }

  AppBar buildSearchToolbar(BuildContext context) {
    return AppBar(
      flexibleSpace: SafeArea(
        child: SearchToolbar(
          key: _textSearchKey,
          showTooltip: true,
          controller: _pdfViewerController,
          onTap: (Object toolbarItem) async {
            if (toolbarItem.toString() == t.bookPage.cancelSearch) {
              setState(() {
                _showToolbar = false;
                _showScrollHead = true;
                if (Navigator.canPop(context)) {
                  Navigator.maybePop(context);
                }
              });
            }
            if (toolbarItem.toString() == 'noResultFound') {
              setState(() {
                _textSearchKey.currentState?.showToast = true;
              });
              await Future.delayed(Duration(seconds: 1));
              setState(() {
                _textSearchKey.currentState?.showToast = false;
              });
            }
          },
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  void _showContextMenu(
    BuildContext context,
    PdfTextSelectionChangedDetails details,
    List<PdfTextLine>? textLines,
  ) {
    const double height = 250;
    const double width = 150;
    final OverlayState overlayState = Overlay.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    double top = details.globalSelectedRegion!.top >= screenSize.height / 2
        ? details.globalSelectedRegion!.top - height - 10
        : details.globalSelectedRegion!.bottom + 20;
    top = top < 0 ? 20 : top;
    top = top + height > screenSize.height
        ? screenSize.height - height - 10
        : top;

    double left = details.globalSelectedRegion!.bottomLeft.dx;
    left = left < 0 ? 10 : left;
    left = left + width > screenSize.width
        ? screenSize.width - width - 10
        : left;
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: top,
        left: left,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          constraints: const BoxConstraints.tightFor(
            width: width,
            height: height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  if (details.selectedText != null) {
                    Clipboard.setData(
                      ClipboardData(text: details.selectedText!),
                    );
                    _pdfViewerController.clearSelection();
                  }
                },
                child: Text(t.bookPage.copy, style: TextStyle(fontSize: 15)),
              ),
              TextButton(
                onPressed: () => PDFUtils.onAddHighlight(
                  textLines,
                  _pdfViewerController,
                  bookId,
                  annoProvider,
                ),
                child: Text(
                  t.bookPage.highlight,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () => PDFUtils.onAddUnderline(
                  textLines,
                  _pdfViewerController,
                  bookId,
                  annoProvider,
                ),
                child: Text(
                  t.bookPage.underline,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () => PDFUtils.onAddStrikethrough(
                  textLines,
                  _pdfViewerController,
                  bookId,
                  annoProvider,
                ),
                child: Text(
                  t.bookPage.strikethrough,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () => PDFUtils.onAddSquiggly(
                  textLines,
                  _pdfViewerController,
                  bookId,
                  annoProvider,
                ),
                child: Text(
                  t.bookPage.squiggly,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!);
  }

  void _showAnnotationsOverlay() {
    if (_annotationsOverlay != null) {
      return;
    }

    final annotations = _pdfViewerController.getAnnotations();
    if (annotations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma anotação encontrada.')),
      );
      return;
    }

    final overlay = Overlay.of(context);
    _annotationsOverlay = OverlayEntry(
      builder: (context) {
        return PageStorage(
          bucket: _annotationsOverlayBucket,
          child: AnnotationsOverlay(
            controller: _pdfViewerController,
            onClose: _hideAnnotationsOverlay,
            bookId: bookId,
            page: _pdfViewerController.pageNumber.toString(),
          ),
        );
      },
    );

    overlay.insert(_annotationsOverlay!);
  }

  void _showNotesOverlay() {
    if (_notesOverlay != null) {
      return;
    }

    final overlay = Overlay.of(context);
    _notesOverlay = OverlayEntry(
      builder: (context) {
        return PageStorage(
          bucket: _notesOverlayBucket,
          child: NotesOverlay(
            onClose: _hideNotesOverlay,
            bookId: bookId,
            page: _pdfViewerController.pageNumber.toString(),
          ),
        );
      },
    );

    overlay.insert(_notesOverlay!);
  }
}
