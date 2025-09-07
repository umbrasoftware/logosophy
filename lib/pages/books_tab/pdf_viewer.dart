import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/utils/pdf_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key, required this.file});

  final File file;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final logger = Logger('PDF Viewer');

  final PdfViewerController _pdfViewerController = PdfViewerController();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late bool _showToolbar;
  late bool _showScrollHead;

  /// Ensure the entry history of Text search.
  LocalHistoryEntry? _historyEntry;

  @override
  void initState() {
    _showToolbar = false;
    _showScrollHead = true;
    super.initState();
  }

  /// Ensure the entry history of text search.
  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
      }
    }
  }

  /// Remove history entry for text search.
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
      appBar: _showToolbar
          ? AppBar(
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
                        _textSearchKey.currentState?._showToast = true;
                      });
                      await Future.delayed(Duration(seconds: 1));
                      setState(() {
                        _textSearchKey.currentState?._showToast = false;
                      });
                    }
                  },
                ),
              ),
              automaticallyImplyLeading: false,
            )
          : AppBar(
              actions: [
                IconButton(icon: Icon(Icons.note_add_sharp), onPressed: () {}),
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
            ),
      body: Stack(
        children: [
          SfPdfViewer.file(
            key: _pdfViewerKey,
            widget.file,
            controller: _pdfViewerController,
            canShowTextSelectionMenu: false,
            canShowScrollHead: _showScrollHead,
            onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
              if (details.selectedText == null && _overlayEntry != null) {
                _overlayEntry!.remove();
                _overlayEntry = null;
              } else if (details.selectedText != null &&
                  _overlayEntry == null) {
                _showContextMenu(context, details);
              }
            },
          ),
          Visibility(
            visible: _textSearchKey.currentState?._showToast ?? false,
            child: Align(
              alignment: Alignment.center,
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      top: 7,
                      right: 15,
                      bottom: 7,
                    ),
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
          ),
        ],
      ),
    );
  }

  void _showContextMenu(
    BuildContext context,
    PdfTextSelectionChangedDetails details,
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
                    logger.info(
                      'Text copied to clipboard: ${details.selectedText}',
                    );
                    _pdfViewerController.clearSelection();
                  }
                },
                child: const Text('Copy', style: TextStyle(fontSize: 15)),
              ),
              TextButton(
                onPressed: () {
                  final List<PdfTextLine>? textLines = _pdfViewerKey
                      .currentState
                      ?.getSelectedTextLines();
                  if (textLines != null && textLines.isNotEmpty) {
                    final HighlightAnnotation highlightAnnotation =
                        HighlightAnnotation(textBoundsCollection: textLines);
                    _pdfViewerController.addAnnotation(highlightAnnotation);

                    final firebaseSelection = PDFUtils.getFirebaseSelection(
                      'highlight',
                      details.selectedText!,
                      details.globalSelectedRegion!,
                      _pdfViewerController.pageNumber,
                      highlightAnnotation.color,
                      highlightAnnotation.opacity,
                    );
                    logger.info('Highlight added: \n$firebaseSelection');
                  }
                },
                child: const Text('Highlight', style: TextStyle(fontSize: 15)),
              ),
              TextButton(
                onPressed: () {
                  final List<PdfTextLine>? textLines = _pdfViewerKey
                      .currentState
                      ?.getSelectedTextLines();
                  if (textLines != null && textLines.isNotEmpty) {
                    final UnderlineAnnotation underLineAnnotation =
                        UnderlineAnnotation(textBoundsCollection: textLines);
                    _pdfViewerController.addAnnotation(underLineAnnotation);

                    final firebaseSelection = PDFUtils.getFirebaseSelection(
                      'underline',
                      details.selectedText!,
                      details.globalSelectedRegion!,
                      _pdfViewerController.pageNumber,
                      underLineAnnotation.color,
                      underLineAnnotation.opacity,
                    );
                    logger.info('Underline added: \n$firebaseSelection');
                  }
                },
                child: const Text('Underline', style: TextStyle(fontSize: 15)),
              ),
              TextButton(
                onPressed: () {
                  final List<PdfTextLine>? textLines = _pdfViewerKey
                      .currentState
                      ?.getSelectedTextLines();
                  if (textLines != null && textLines.isNotEmpty) {
                    final StrikethroughAnnotation strikethroughAnnotation =
                        StrikethroughAnnotation(
                          textBoundsCollection: textLines,
                        );
                    _pdfViewerController.addAnnotation(strikethroughAnnotation);

                    final firebaseSelection = PDFUtils.getFirebaseSelection(
                      'strikethrough',
                      details.selectedText!,
                      details.globalSelectedRegion!,
                      _pdfViewerController.pageNumber,
                      strikethroughAnnotation.color,
                      strikethroughAnnotation.opacity,
                    );
                    logger.info('Strikethrough added: \n$firebaseSelection');
                  }
                },
                child: const Text(
                  'Strikethrough',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () {
                  final List<PdfTextLine>? textLines = _pdfViewerKey
                      .currentState
                      ?.getSelectedTextLines();
                  if (textLines != null && textLines.isNotEmpty) {
                    final SquigglyAnnotation squigglyAnnotation =
                        SquigglyAnnotation(textBoundsCollection: textLines);
                    _pdfViewerController.addAnnotation(squigglyAnnotation);

                    final firebaseSelection = PDFUtils.getFirebaseSelection(
                      'squiggly',
                      details.selectedText!,
                      details.globalSelectedRegion!,
                      _pdfViewerController.pageNumber,
                      squigglyAnnotation.color,
                      squigglyAnnotation.opacity,
                    );
                    logger.info('Squiggly added: \n$firebaseSelection');
                  }
                },
                child: const Text('Squiggly', style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!);
  }
}

/// Signature for the [SearchToolbar.onTap] callback.
typedef SearchTapCallback = void Function(Object item);

/// SearchToolbar widget
class SearchToolbar extends StatefulWidget {
  ///it describe the search toolbar constructor
  const SearchToolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    super.key,
  });

  /// Indicates whether the tooltip for the search toolbar items need to be shown or not.
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController? controller;

  /// Called when the search toolbar item is selected.
  final SearchTapCallback? onTap;

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

/// State for the SearchToolbar widget
class SearchToolbarState extends State<SearchToolbar> {
  /// Indicates whether search is initiated or not.
  bool _isSearchInitiated = false;

  /// Indicates whether search toast need to be shown or not.
  bool _showToast = false;

  ///An object that is used to retrieve the current value of the TextField.
  final TextEditingController _editingController = TextEditingController();

  /// An object that is used to retrieve the text search result.
  PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();

  ///An object that is used to obtain keyboard focus and to handle keyboard events.
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode?.requestFocus();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode?.dispose();
    _pdfTextSearchResult.removeListener(() {});
    super.dispose();
  }

  ///Clear the text search result
  void clearSearch() {
    _isSearchInitiated = false;
    _pdfTextSearchResult.clear();
  }

  ///Display the Alert dialog to search from the beginning
  void _showSearchAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(0),
          title: Text(t.bookPage.searchResult),
          content: SizedBox(
            width: 328.0,
            child: Text(t.bookPage.noMoreResults),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _pdfTextSearchResult.nextInstance();
                });
                Navigator.of(context).pop();
              },
              child: Text(
                t.bookPage.YES,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _pdfTextSearchResult.clear();
                  _editingController.clear();
                  _isSearchInitiated = false;
                  focusNode?.requestFocus();
                });
                Navigator.of(context).pop();
              },
              child: Text(
                t.bookPage.NO,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: 24),
            onPressed: () {
              widget.onTap?.call(t.bookPage.cancelSearch);
              _isSearchInitiated = false;
              _editingController.clear();
              _pdfTextSearchResult.clear();
            },
          ),
        ),
        Flexible(
          child: TextFormField(
            style: TextStyle(fontSize: 16),
            enableInteractiveSelection: false,
            focusNode: focusNode,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            controller: _editingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: t.bookPage.find,
            ),
            onChanged: (text) {
              if (_editingController.text.isNotEmpty) {
                setState(() {});
              }
            },
            onFieldSubmitted: (String value) {
              _isSearchInitiated = true;
              _pdfTextSearchResult = widget.controller!.searchText(
                _editingController.text,
              );
              _pdfTextSearchResult.addListener(() {
                if (super.mounted) {
                  setState(() {});
                }
                if (!_pdfTextSearchResult.hasResult &&
                    _pdfTextSearchResult.isSearchCompleted) {
                  widget.onTap?.call('noResultFound');
                }
              });
            },
          ),
        ),
        Visibility(
          visible: _editingController.text.isNotEmpty,
          child: Material(
            child: IconButton(
              icon: Icon(Icons.clear, size: 24),
              onPressed: () {
                setState(() {
                  _editingController.clear();
                  _pdfTextSearchResult.clear();
                  widget.controller!.clearSelection();
                  _isSearchInitiated = false;
                  focusNode!.requestFocus();
                });
                widget.onTap!.call(t.bookPage.clearText);
              },
              tooltip: widget.showTooltip ? t.bookPage.clearText : null,
            ),
          ),
        ),
        Visibility(
          visible:
              !_pdfTextSearchResult.isSearchCompleted && _isSearchInitiated,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        Visibility(
          visible: _pdfTextSearchResult.hasResult,
          child: Row(
            children: [
              Text(
                '${_pdfTextSearchResult.currentInstanceIndex}',
                style: TextStyle(fontSize: 16),
              ),
              Text(' of ', style: TextStyle(fontSize: 16)),
              Text(
                '${_pdfTextSearchResult.totalInstanceCount}',
                style: TextStyle(fontSize: 16),
              ),
              Material(
                child: IconButton(
                  icon: Icon(Icons.navigate_before, size: 24),
                  onPressed: () {
                    setState(() {
                      _pdfTextSearchResult.previousInstance();
                    });
                    widget.onTap!.call(t.bookPage.previousInstance);
                  },
                  tooltip: widget.showTooltip ? t.bookPage.previous : null,
                ),
              ),
              Material(
                child: IconButton(
                  icon: Icon(Icons.navigate_next, size: 24),
                  onPressed: () {
                    setState(() {
                      if (_pdfTextSearchResult.currentInstanceIndex ==
                              _pdfTextSearchResult.totalInstanceCount &&
                          _pdfTextSearchResult.currentInstanceIndex != 0 &&
                          _pdfTextSearchResult.totalInstanceCount != 0 &&
                          _pdfTextSearchResult.isSearchCompleted) {
                        _showSearchAlertDialog(context);
                      } else {
                        widget.controller!.clearSelection();
                        _pdfTextSearchResult.nextInstance();
                      }
                    });
                    widget.onTap!.call(t.bookPage.nextInstance);
                  },
                  tooltip: widget.showTooltip ? t.bookPage.next : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
