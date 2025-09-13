import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:logosophy/database/books/book_cache.dart';
import 'package:logosophy/database/books/selection_span.dart';
import 'package:logosophy/gen/strings.g.dart';
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
        String allText = '';
        for (final textLine in span.textLines) {
          textLines.add(PdfTextLine(textLine.bounds, textLine.text, page));
          allText += '${textLine.text} ';
        }

        switch (span.type) {
          case 'highlight':
            final highlight = HighlightAnnotation(
              textBoundsCollection: textLines,
            );
            highlight.color = Color(span.color);
            highlight.opacity = span.opacity;
            highlight.name = allText;
            pdfViewerController.addAnnotation(highlight);
            break;
          case 'underline':
            final underline = UnderlineAnnotation(
              textBoundsCollection: textLines,
            );
            underline.color = Color(span.color);
            underline.opacity = span.opacity;
            underline.name = allText;
            pdfViewerController.addAnnotation(underline);
            break;
          case 'strikethrough':
            final strikethrough = StrikethroughAnnotation(
              textBoundsCollection: textLines,
            );
            strikethrough.color = Color(span.color);
            strikethrough.opacity = span.opacity;
            strikethrough.name = allText;
            pdfViewerController.addAnnotation(strikethrough);
            break;
          case 'squiggly':
            final squiggly = SquigglyAnnotation(
              textBoundsCollection: textLines,
            );
            squiggly.color = Color(span.color);
            squiggly.opacity = span.opacity;
            squiggly.name = allText;
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

  static String getAnnotationName(Annotation annotation) {
    if (annotation is HighlightAnnotation) return t.bookPage.highlight;
    if (annotation is UnderlineAnnotation) return t.bookPage.underline;
    if (annotation is StrikethroughAnnotation) return t.bookPage.strikethrough;
    if (annotation is SquigglyAnnotation) return t.bookPage.squiggly;

    return 'error';
  }
}
