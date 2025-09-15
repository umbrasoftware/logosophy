import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logosophy/database/books/book.dart';
import 'package:logosophy/database/books/book_provider.dart';
import 'package:logosophy/database/books/selection_span.dart';
import 'package:logosophy/utils/pdf_utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AnnotationsOverlay extends ConsumerStatefulWidget {
  final PdfViewerController controller;
  final VoidCallback onClose;

  const AnnotationsOverlay({
    super.key,
    required this.controller,
    required this.onClose,
  });

  @override
  ConsumerState<AnnotationsOverlay> createState() => _AnnotationsOverlayState();
}

class _AnnotationsOverlayState extends ConsumerState<AnnotationsOverlay> {
  late Book book;
  late BookNotifier bookProvider;
  late List<SelectionSpan> spans;

  @override
  void initState() {
    super.initState();
    book = ref.read(bookNotifierProvider);
    bookProvider = ref.read(bookNotifierProvider.notifier);
    spans = PDFUtils.getSpans(book.selections);
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

  ListView buildListViewer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: spans.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            trailing: IconButton(
              onPressed: () async {
                if (await PDFUtils.removeSelection(
                  spans[index],
                  widget.controller,
                  bookProvider,
                )) {
                  setState(() {
                    spans.removeAt(index);
                  });
                }
              },
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            title: Text('Página ${spans[index].pageNumber}'),
            subtitle: Text(
              PDFUtils.getAllText(spans[index].textLines),
              overflow: TextOverflow.ellipsis,
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
            'Anotações do livro',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: widget.onClose),
        ],
      ),
    );
  }
}
