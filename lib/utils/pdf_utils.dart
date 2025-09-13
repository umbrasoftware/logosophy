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

  static void onAddSquiggly(
    GlobalKey<SfPdfViewerState> pdfViewerKey,
    PdfViewerController controller,
    Book book,
    BookNotifier bookProvider,
  ) {
    final List<PdfTextLine>? textLines = pdfViewerKey.currentState
        ?.getSelectedTextLines();
    if (textLines != null && textLines.isNotEmpty) {
      final SquigglyAnnotation squigglyAnnotation = SquigglyAnnotation(
        textBoundsCollection: textLines,
      );
      controller.addAnnotation(squigglyAnnotation);

      final pageNumber = textLines.first.pageNumber;
      // Convert PdfTextLine to a serializable Map.
      final span = SelectionSpan(
        textLines: textLines
            .map(
              (line) =>
                  SerializablePdfTextLine(text: line.text, bounds: line.bounds),
            )
            .toList(),
        type: 'squiggly',
        pageNumber: pageNumber,
        color: squigglyAnnotation.color.toARGB32(),
        opacity: squigglyAnnotation.opacity,
      );

      final existingSpans = book.selections[pageNumber.toString()] ?? [];
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
    final List<PdfTextLine>? textLines = pdfViewerKey.currentState
        ?.getSelectedTextLines();
    if (textLines != null && textLines.isNotEmpty) {
      final StrikethroughAnnotation strikethroughAnnotation =
          StrikethroughAnnotation(textBoundsCollection: textLines);
      controller.addAnnotation(strikethroughAnnotation);

      final pageNumber = textLines.first.pageNumber;
      // Convert PdfTextLine to a serializable Map.
      final span = SelectionSpan(
        textLines: textLines
            .map(
              (line) =>
                  SerializablePdfTextLine(text: line.text, bounds: line.bounds),
            )
            .toList(),
        type: 'strikethrough',
        pageNumber: pageNumber,
        color: strikethroughAnnotation.color.toARGB32(),
        opacity: strikethroughAnnotation.opacity,
      );

      final existingSpans = book.selections[pageNumber.toString()] ?? [];
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
    final List<PdfTextLine>? textLines = pdfViewerKey.currentState
        ?.getSelectedTextLines();
    if (textLines != null && textLines.isNotEmpty) {
      final UnderlineAnnotation underLineAnnotation = UnderlineAnnotation(
        textBoundsCollection: textLines,
      );
      controller.addAnnotation(underLineAnnotation);

      final pageNumber = textLines.first.pageNumber;
      // Convert PdfTextLine to a serializable Map.
      final span = SelectionSpan(
        textLines: textLines
            .map(
              (line) =>
                  SerializablePdfTextLine(text: line.text, bounds: line.bounds),
            )
            .toList(),
        type: 'underline',
        pageNumber: pageNumber,
        color: underLineAnnotation.color.toARGB32(),
        opacity: underLineAnnotation.opacity,
      );

      final existingSpans = book.selections[pageNumber.toString()] ?? [];
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
    final List<PdfTextLine>? textLines = pdfViewerKey.currentState
        ?.getSelectedTextLines();
    if (textLines != null && textLines.isNotEmpty) {
      final HighlightAnnotation highlightAnnotation = HighlightAnnotation(
        textBoundsCollection: textLines,
      );
      controller.addAnnotation(highlightAnnotation);

      final pageNumber = textLines.first.pageNumber;
      // Convert PdfTextLine to a serializable Map.
      final span = SelectionSpan(
        textLines: textLines
            .map(
              (line) =>
                  SerializablePdfTextLine(text: line.text, bounds: line.bounds),
            )
            .toList(),
        type: 'highlight',
        pageNumber: pageNumber,
        color: highlightAnnotation.color.toARGB32(),
        opacity: highlightAnnotation.opacity,
      );

      final existingSpans = book.selections[pageNumber.toString()] ?? [];
      bookProvider.updateSelectionsForPage(pageNumber, [
        ...existingSpans,
        span,
      ]);
      controller.clearSelection();
    }
  }
}
