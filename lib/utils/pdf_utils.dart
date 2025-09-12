import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:logosophy/database/books/book_cache.dart';
import 'package:logosophy/database/books/selection_span.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFUtils {
  static final logger = Logger('PdfUtils');

  static void applySelections(
    PdfViewerController pdfViewerController,
    Map<String, List<SelectionSpan>> selections,
  ) {
    for (final entry in selections.entries) {
      final page = int.parse(entry.key);
      final selectionSpan = entry.value;

      // Begings processing for a page:
      for (final span in selectionSpan) {
        List<PdfTextLine> textLines = [];
        for (final textLine in span.textLines) {
          textLines.add(PdfTextLine(textLine.bounds, textLine.text, page));
        }

        switch (span.type) {
          case 'highlight':
            final highlight = HighlightAnnotation(
              textBoundsCollection: textLines,
            );
            highlight.color = Color(span.color);
            highlight.opacity = span.opacity;
            pdfViewerController.addAnnotation(highlight);
            break;
          case 'underline':
            final underline = UnderlineAnnotation(
              textBoundsCollection: textLines,
            );
            underline.color = Color(span.color);
            underline.opacity = span.opacity;
            pdfViewerController.addAnnotation(underline);
            break;
          case 'strikethrough':
            final strikethrough = StrikethroughAnnotation(
              textBoundsCollection: textLines,
            );
            strikethrough.color = Color(span.color);
            strikethrough.opacity = span.opacity;
            pdfViewerController.addAnnotation(strikethrough);
            break;
          case 'squiggly':
            final squiggly = SquigglyAnnotation(
              textBoundsCollection: textLines,
            );
            squiggly.color = Color(span.color);
            squiggly.opacity = span.opacity;
            pdfViewerController.addAnnotation(squiggly);
            break;
          default:
            break;
        }
      }
    }
  }

  static void savePosition(String bookId, PdfViewerController controller) {
    BookCache().savePosition(
      bookId,
      offset: controller.scrollOffset,
      zoom: controller.zoomLevel,
    );
  }
}
