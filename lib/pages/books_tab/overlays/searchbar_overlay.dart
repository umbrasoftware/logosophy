// searchbar_overlay.dart

import 'package:flutter/material.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
  bool showToast = false;

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
