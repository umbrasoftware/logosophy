import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/annotations/annotations_provider.dart';
import 'package:logosophy/database/annotations/models/selection_span.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/utils/pdf_utils.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AnnotationsOverlay extends ConsumerStatefulWidget {
  final PdfViewerController controller;
  final VoidCallback onClose;
  final String bookId;
  final String page;

  const AnnotationsOverlay({
    super.key,
    required this.controller,
    required this.onClose,
    required this.bookId,
    required this.page,
  });

  @override
  ConsumerState<AnnotationsOverlay> createState() => _AnnotationsOverlayState();
}

class _AnnotationsOverlayState extends ConsumerState<AnnotationsOverlay> {
  late AnnotationsNotifier annoProvider;
  late List<SelectionSpan> spans;
  late int page;

  final ItemScrollController _itemScrollController = ItemScrollController();
  late int _initialIndex;

  @override
  void initState() {
    super.initState();
    page = int.parse(widget.page);
    annoProvider = ref.read(annotationsNotifierProvider.notifier);
    spans = annoProvider.getSelectionSpans(widget.bookId)
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

    final targetIndex = spans.indexWhere((span) => span.pageNumber >= page);

    _initialIndex = targetIndex != -1 ? targetIndex : 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withAlpha(126),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  children: [
                    buildCardTitle(),
                    const Divider(height: 1),
                    Expanded(child: buildListViewer()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListViewer() {
    return ScrollablePositionedList.builder(
      padding: const EdgeInsets.all(16),
      itemCount: spans.length,
      itemScrollController: _itemScrollController,
      initialScrollIndex: _initialIndex,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            onTap: () {
              widget.controller.jumpToPage(spans[index].pageNumber);
              widget.onClose();
            },
            trailing: IconButton(
              onPressed: () async {
                await PDFUtils.removeSelection(
                  widget.bookId,
                  spans[index],
                  widget.controller,
                  annoProvider,
                );
                setState(() {
                  spans.removeAt(index);
                });
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            title: Text(t.bookPage.page(page: spans[index].pageNumber)),
            subtitle: Text(
              PDFUtils.getAllText(spans[index].textLines),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: PDFUtils.getTextSyle(
                spans[index].color,
                spans[index].type,
              ),
            ),
          ),
        );
      },
    );
  }

  Padding buildCardTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            t.bookPage.bookAnnotations,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: widget.onClose),
        ],
      ),
    );
  }
}
