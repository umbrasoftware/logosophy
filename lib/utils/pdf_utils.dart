import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/books/book.dart';
import 'package:logosophy/database/books/book_cache.dart';
import 'package:logosophy/database/books/book_provider.dart';
import 'package:logosophy/database/books/rect_converter.dart';
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
            addAnnotationProperties(highlight, span, allText);
            pdfViewerController.addAnnotation(highlight);
            break;
          case 'underline':
            final underline = UnderlineAnnotation(
              textBoundsCollection: textLines,
            );
            addAnnotationProperties(underline, span, allText);
            pdfViewerController.addAnnotation(underline);
            break;
          case 'strikethrough':
            final strikethrough = StrikethroughAnnotation(
              textBoundsCollection: textLines,
            );
            addAnnotationProperties(strikethrough, span, allText);
            pdfViewerController.addAnnotation(strikethrough);
            break;
          case 'squiggly':
            final squiggly = SquigglyAnnotation(
              textBoundsCollection: textLines,
            );
            addAnnotationProperties(squiggly, span, allText);
            pdfViewerController.addAnnotation(squiggly);
            break;
          default:
            break;
        }
      }
    }
  }

  /// Add some properties to a given abstract annotation.
  static void addAnnotationProperties(
    Annotation annotation,
    SelectionSpan span,
    String allText,
  ) {
    annotation.color = Color(span.color);
    annotation.opacity = span.opacity;
    annotation.name = allText;
  }

  static void savePosition(String bookId, PdfViewerController controller) {
    BookCache().savePosition(
      bookId,
      offset: controller.scrollOffset,
      zoom: controller.zoomLevel,
    );
  }

  /// Add a squiggly annonation to the PDF and then updates it to Firebase.
  static void onAddSquiggly(
    GlobalKey<SfPdfViewerState> pdfViewerKey,
    PdfViewerController controller,
    Book book,
    BookNotifier bookProvider,
  ) {
    final textLines = pdfViewerKey.currentState?.getSelectedTextLines();
    if (textLines != null && textLines.isNotEmpty) {
      final squigglyAnno = SquigglyAnnotation(textBoundsCollection: textLines);
      controller.addAnnotation(squigglyAnno);
      final span = makeSelectionSpan(textLines, 'squiggly', squigglyAnno);

      final pageNumber = textLines.first.pageNumber.toString();
      final existingSpans = book.selections[pageNumber] ?? [];
      bookProvider.updateSelectionsForPage(pageNumber, [
        ...existingSpans,
        span,
      ]);
      controller.clearSelection();
    }
  }

  static void onAddStrikethrough(
    GlobalKey<SfPdfViewerState> pdfViewerKey,
    PdfViewerController controller,
    Book book,
    BookNotifier bookProvider,
  ) {
    final textLines = pdfViewerKey.currentState?.getSelectedTextLines();
    if (textLines != null && textLines.isNotEmpty) {
      final strikeAnno = StrikethroughAnnotation(
        textBoundsCollection: textLines,
      );
      controller.addAnnotation(strikeAnno);
      final span = makeSelectionSpan(textLines, 'strikethrough', strikeAnno);

      final pageNumber = textLines.first.pageNumber.toString();
      final existingSpans = book.selections[pageNumber] ?? [];
      bookProvider.updateSelectionsForPage(pageNumber, [
        ...existingSpans,
        span,
      ]);
      controller.clearSelection();
    }
  }

  static void onAddUnderline(
    GlobalKey<SfPdfViewerState> pdfViewerKey,
    PdfViewerController controller,
    Book book,
    BookNotifier bookProvider,
  ) {
    final textLines = pdfViewerKey.currentState?.getSelectedTextLines();
    if (textLines != null && textLines.isNotEmpty) {
      final underLineAnno = UnderlineAnnotation(
        textBoundsCollection: textLines,
      );
      controller.addAnnotation(underLineAnno);
      final span = makeSelectionSpan(textLines, 'underline', underLineAnno);

      final pageNumber = textLines.first.pageNumber.toString();
      final existingSpans = book.selections[pageNumber] ?? [];
      bookProvider.updateSelectionsForPage(pageNumber, [
        ...existingSpans,
        span,
      ]);
      controller.clearSelection();
    }
  }

  static void onAddHighlight(
    GlobalKey<SfPdfViewerState> pdfViewerKey,
    PdfViewerController controller,
    Book book,
    BookNotifier bookProvider,
  ) {
    final textLines = pdfViewerKey.currentState?.getSelectedTextLines();
    if (textLines != null && textLines.isNotEmpty) {
      final highlightAnno = HighlightAnnotation(
        textBoundsCollection: textLines,
      );
      controller.addAnnotation(highlightAnno);
      final span = makeSelectionSpan(textLines, 'highlight', highlightAnno);

      final pageNumber = textLines.first.pageNumber.toString();
      final existingSpans = book.selections[pageNumber] ?? [];
      bookProvider.updateSelectionsForPage(pageNumber, [
        ...existingSpans,
        span,
      ]);
      controller.clearSelection();
    }
  }

  /// Convert PdfTextLine to a serializable Map.
  static SelectionSpan makeSelectionSpan(
    List<PdfTextLine> textLines,
    String type,
    Annotation annotation,
  ) {
    return SelectionSpan(
      textLines: textLines
          .map(
            (line) =>
                SerializablePdfTextLine(text: line.text, bounds: line.bounds),
          )
          .toList(),
      type: type,
      pageNumber: textLines.first.pageNumber,
      color: annotation.color.toARGB32(),
      opacity: annotation.opacity,
    );
  }
}
