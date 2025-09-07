import 'dart:ui';

import 'package:logging/logging.dart';

class PDFUtils {
  static final _logger = Logger('PDF Utils');

  static FirebaseSelection getFirebaseSelection(
    String type,
    String text,
    Rect rect,
    int pageNumber,
    Color color,
    double opacity,
  ) {
    _logger.fine(
      'Creating FirebaseSelection: text="$text", rect=$rect, '
      'pageNumber=$pageNumber, color=$color, opacity=$opacity',
    );
    return FirebaseSelection(
      type: type,
      text: text,
      rect: [rect.left, rect.top, rect.right, rect.bottom],
      pageNumber: pageNumber,
      color: [color.a, color.r, color.g, color.b],
      opacity: opacity,
    );
  }
}

/// A model class that represents a text selection in a PDF document for Firebase storage.
/// The [rect] is (left, top, right, bottom).
/// The [color] is (alpha, red, green, blue).
class FirebaseSelection {
  final String type;
  final String text;
  final List<double> rect;
  final int pageNumber;
  final List<double> color;
  final double opacity;

  FirebaseSelection({
    required this.type,
    required this.text,
    required this.rect,
    required this.pageNumber,
    required this.color,
    required this.opacity,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'rect': rect,
      'text': text,
      'pageNumber': pageNumber,
      'color': color,
      'opacity': opacity,
    };
  }

  factory FirebaseSelection.fromJson(Map<String, dynamic> json) {
    return FirebaseSelection(
      type: json['type'],
      rect: List<double>.from(json['rect']),
      text: json['text'],
      pageNumber: json['pageNumber'],
      color: List<double>.from(json['color']),
      opacity: json['opacity'],
    );
  }

  @override
  String toString() {
    return 'FirebaseSelection(type: $type, text: $text, rect: $rect, pageNumber: $pageNumber, color: $color, opacity: $opacity)';
  }
}
