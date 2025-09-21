import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:logosophy/database/annotations/annotations_provider.dart';
import 'package:logosophy/database/annotations/models/page_annotations.dart';
import 'package:logosophy/database/annotations/models/rect_converter.dart';
import 'package:logosophy/database/annotations/models/selection_span.dart';
import 'package:logosophy/database/cache/book_cache.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFUtils {
  static final logger = Logger('PdfUtils');

  /// Apply annotations to a book.
  static void applySelections(
    PdfViewerController pdfViewerController,
    List<SelectionSpan> selections,
  ) {
    for (final selectionSpan in selections) {
      final annotation = getAnnotationFromSpan(selectionSpan);
      pdfViewerController.addAnnotation(annotation);
    }
  }

  /// This function delete the exact selection instance from the PDF and
  /// Firebase, if a match is found. It compares against the current annotations
  /// in place. The comparisson is made using the pageNumber and the text of the
  /// selection itself, that is on the variable `annontation.name`.
  ///  Returns true in case of success.
  static Future<bool> removeSelection(
    String bookId,
    SelectionSpan span,
    PdfViewerController controller,
    AnnotationsNotifier annoProvider,
  ) async {
    Annotation? annotationObjectToRemove;
    final allAnnotations = controller.getAnnotations();

    for (final currentAnnotation in allAnnotations) {
      if (compareSpanAgainstAnnotation(span, currentAnnotation)) {
        annotationObjectToRemove = currentAnnotation;
      }
    }

    if (annotationObjectToRemove != null) {
      final page = span.pageNumber.toString();
      controller.removeAnnotation(annotationObjectToRemove);
      final spansToKeep = annoProvider.removeAnnotationFromBook(bookId, span);
      if (spansToKeep != null) {
        await annoProvider.updateSelectionsForPage(bookId, page, spansToKeep);
        logger.info('Successfully removed annotation from PDF and Firebase');
        return true;
      }
    }
    logger.warning('Could not find the associated annotation to remove.');
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
    if (annotation.name == null) {
      return false;
    }

    String spanText = '';
    for (final span in span.textLines) {
      spanText += span.text;
    }

    if (annotation.pageNumber == span.pageNumber &&
        annotation.name == spanText) {
      return true;
    }
    return false;
  }

  /// Compare two selections spans by their text.
  static bool compareSelectionSpans(SelectionSpan s1, SelectionSpan s2) {
    if (s1.pageNumber != s2.pageNumber) return false;
    if (s1.textLines.length != s2.textLines.length) return false;

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
    List<PdfTextLine>? textLines,
    PdfViewerController controller,
    String bookId,
    AnnotationsNotifier annoProvider,
  ) {
    if (textLines != null && textLines.isNotEmpty) {
      final squigglyAnno = SquigglyAnnotation(textBoundsCollection: textLines);
      squigglyAnno.name = textLines.map((line) => line.text).join('');
      controller.addAnnotation(squigglyAnno);
      final span = makeSelectionSpan(textLines, 'squiggly', squigglyAnno);

      final page = textLines.first.pageNumber.toString();
      final existingSpans = annoProvider.getSelectionSpans(bookId, page: page);
      annoProvider.updateSelectionsForPage(bookId, page, [
        ...existingSpans,
        span,
      ]);
      controller.clearSelection();
    }
  }

  static void onAddStrikethrough(
    List<PdfTextLine>? textLines,
    PdfViewerController controller,
    String bookId,
    AnnotationsNotifier annoProvider,
  ) {
    if (textLines != null && textLines.isNotEmpty) {
      final strikeAnno = StrikethroughAnnotation(
        textBoundsCollection: textLines,
      );
      strikeAnno.name = textLines.map((line) => line.text).join('');
      controller.addAnnotation(strikeAnno);
      final span = makeSelectionSpan(textLines, 'strikethrough', strikeAnno);

      final page = textLines.first.pageNumber.toString();
      final existingSpans = annoProvider.getSelectionSpans(bookId, page: page);
      annoProvider.updateSelectionsForPage(bookId, page, [
        ...existingSpans,
        span,
      ]);
      controller.clearSelection();
    }
  }

  static void onAddUnderline(
    List<PdfTextLine>? textLines,
    PdfViewerController controller,
    String bookId,
    AnnotationsNotifier annoProvider,
  ) {
    if (textLines != null && textLines.isNotEmpty) {
      final underLineAnno = UnderlineAnnotation(
        textBoundsCollection: textLines,
      );
      underLineAnno.name = textLines.map((line) => line.text).join('');
      controller.addAnnotation(underLineAnno);
      final span = makeSelectionSpan(textLines, 'underline', underLineAnno);

      final page = textLines.first.pageNumber.toString();
      final existingSpans = annoProvider.getSelectionSpans(bookId, page: page);
      annoProvider.updateSelectionsForPage(bookId, page, [
        ...existingSpans,
        span,
      ]);
      controller.clearSelection();
    }
  }

  static void onAddHighlight(
    List<PdfTextLine>? textLines,
    PdfViewerController controller,
    String bookId,
    AnnotationsNotifier annoProvider,
  ) {
    if (textLines != null && textLines.isNotEmpty) {
      final highlightAnno = HighlightAnnotation(
        textBoundsCollection: textLines,
      );
      highlightAnno.name = textLines.map((line) => line.text).join('');
      controller.addAnnotation(highlightAnno);
      final span = makeSelectionSpan(textLines, 'highlight', highlightAnno);

      final page = textLines.first.pageNumber.toString();
      final existingSpans = annoProvider.getSelectionSpans(bookId, page: page);
      annoProvider.updateSelectionsForPage(bookId, page, [
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

  static TextStyle getTextSyle(int color, String type) {
    switch (type) {
      case 'highlight':
        return TextStyle(backgroundColor: Color(color));

      case 'underline':
        return TextStyle(
          decoration: TextDecoration.underline,
          decorationColor: Color(color),
          decorationThickness: 2.0,
        );

      case 'strikethrough':
        return TextStyle(
          decoration: TextDecoration.lineThrough,
          decorationColor: Color(color),
          decorationThickness: 2.0,
        );

      case 'squiggly':
        return TextStyle(
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.wavy,
          decorationColor: Color(color),
          decorationThickness: 2.0,
        );

      default:
        return TextStyle();
    }
  }
}

final Map<String, dynamic> bookInitMapFirebase = {
  'book': {
    '001': {'page': <String, dynamic>{}},
    '002': {'page': <String, dynamic>{}},
    '003': {'page': <String, dynamic>{}},
    '004': {'page': <String, dynamic>{}},
    '005': {'page': <String, dynamic>{}},
    '006': {'page': <String, dynamic>{}},
    '007': {'page': <String, dynamic>{}},
    '008': {'page': <String, dynamic>{}},
    '009': {'page': <String, dynamic>{}},
    '010': {'page': <String, dynamic>{}},
    '011': {'page': <String, dynamic>{}},
    '012': {'page': <String, dynamic>{}},
    '013': {'page': <String, dynamic>{}},
    '014': {'page': <String, dynamic>{}},
    '015': {'page': <String, dynamic>{}},
    '016': {'page': <String, dynamic>{}},
    '017': {'page': <String, dynamic>{}},
  },
};

final Map<String, PageAnnotations> bookInitMap = {
  "001": PageAnnotations(page: {}),
  "002": PageAnnotations(page: {}),
  "003": PageAnnotations(page: {}),
  "004": PageAnnotations(page: {}),
  "005": PageAnnotations(page: {}),
  "006": PageAnnotations(page: {}),
  "007": PageAnnotations(page: {}),
  "008": PageAnnotations(page: {}),
  "009": PageAnnotations(page: {}),
  "010": PageAnnotations(page: {}),
  "011": PageAnnotations(page: {}),
  "012": PageAnnotations(page: {}),
  "013": PageAnnotations(page: {}),
  "014": PageAnnotations(page: {}),
  "015": PageAnnotations(page: {}),
  "016": PageAnnotations(page: {}),
  "017": PageAnnotations(page: {}),
};
