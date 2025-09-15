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
    for (final selectionSpan in selections.values) {
      for (final span in selectionSpan) {
        final annotation = getAnnotationFromSpan(span);
        pdfViewerController.addAnnotation(annotation);
      }
    }
  }

  /// This function delete the exact selection instance from the PDF and
  /// Firebase, if a match is found. It compares against the current annotations
  /// in place. The comparisson is made using the pageNumber and the text of the
  /// selection itself, that is on the variable `annontation.name`.
  ///  Returns true in case of success.
  static Future<bool> removeSelection(
    SelectionSpan span,
    PdfViewerController controller,
    BookNotifier bookProvider,
  ) async {
    Annotation? annotationObjectToRemove;
    final List<Annotation> allAnnotations = controller.getAnnotations();

    for (final currentAnnotation in allAnnotations) {
      if (compareSpanAgainstAnnotation(span, currentAnnotation)) {
        annotationObjectToRemove = currentAnnotation;
      }
    }

    if (annotationObjectToRemove != null) {
      final page = span.pageNumber.toString();
      controller.removeAnnotation(annotationObjectToRemove);
      final spansToKeep = bookProvider.removeAnnotationFromBook(span);
      if (spansToKeep != null) {
        await bookProvider.updateSelectionsForPage(page, spansToKeep);
        return true;
      }
    }
    return false;
  }

  /// Compares [SelectionSpan] against a [Annotation] and returns if they are
  /// the same.
  ///
  /// CAUTION: The values used to compare are the `annotation.name`, which
  /// should be all the text combined and the pageNumber.
  static bool compareSpanAgainstAnnotation(
    SelectionSpan span,
    Annotation annotation,
  ) {
    String spanText = '';
    for (final span in span.textLines) {
      spanText += span.text;
    }

    if (annotation.name == spanText &&
        annotation.pageNumber == span.pageNumber) {
      return true;
    }
    return false;
  }

  static bool compareSelectionSpans(SelectionSpan s1, SelectionSpan s2) {
    if (s1.textLines.length != s2.textLines.length) return false;
    if (s1.pageNumber != s2.pageNumber) return false;

    String s1Text = '';
    String s2Text = '';
    for (final textLine in s1.textLines) {
      s1Text += textLine.text;
    }
    for (final textLine in s2.textLines) {
      s2Text += textLine.text;
    }
    if (s1Text != s2Text) return false;

    return true;
  }

  static List<SelectionSpan> getSpans(
    Map<String, List<SelectionSpan>> selections,
  ) {
    final selects = selections.entries.toList();
    selects.sort((k1, k2) => k1.key.compareTo(k2.key));

    final List<SelectionSpan> out = [];
    for (var map in selects) {
      for (var spans in map.value) {
        out.add(spans);
      }
    }

    return out;
  }

  static String getAllText(List<SerializablePdfTextLine> textLines) {
    String combinedText = '';
    for (final text in textLines) {
      combinedText += text.text;
    }

    return combinedText;
  }

  static Annotation getAnnotationFromSpan(SelectionSpan span) {
    List<PdfTextLine> textLines = [];
    late Annotation annotation;
    String allText = '';
    for (final textLine in span.textLines) {
      textLines.add(
        PdfTextLine(textLine.bounds, textLine.text, span.pageNumber),
      );
      allText += textLine.text;
    }

    switch (span.type) {
      case 'highlight':
        annotation = HighlightAnnotation(textBoundsCollection: textLines);
        addAnnotationProperties(annotation, span, allText);
        break;
      case 'underline':
        annotation = UnderlineAnnotation(textBoundsCollection: textLines);
        addAnnotationProperties(annotation, span, allText);
        break;
      case 'strikethrough':
        annotation = StrikethroughAnnotation(textBoundsCollection: textLines);
        addAnnotationProperties(annotation, span, allText);
        break;
      case 'squiggly':
        annotation = SquigglyAnnotation(textBoundsCollection: textLines);
        addAnnotationProperties(annotation, span, allText);
        break;
    }

    return annotation;
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
