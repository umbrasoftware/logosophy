import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logosophy/database/annotations/models/rect_converter.dart';

part 'selection_span.freezed.dart';
part 'selection_span.g.dart';

/// This is the type definition for an `Annotation` to be store in the Firebase.
@freezed
abstract class SelectionSpan with _$SelectionSpan {
  factory SelectionSpan({
    required List<SerializablePdfTextLine> textLines,
    required String type,
    required int pageNumber,
    required int color,
    required double opacity,
  }) = _SelectionSpan;

  factory SelectionSpan.fromJson(Map<String, dynamic> json) =>
      _$SelectionSpanFromJson(json);
}
