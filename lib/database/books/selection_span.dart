import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logosophy/database/books/rect_converter.dart';

part 'selection_span.freezed.dart';
part 'selection_span.g.dart';

@freezed
abstract class SelectionSpan with _$SelectionSpan {
  factory SelectionSpan({
    // 2. Usamos a nossa classe serializável aqui!
    required List<SerializablePdfTextLine> textLines,
    required String type,
    required int pageNumber,
    required int color,
    required double opacity,
  }) = _SelectionSpan;

  factory SelectionSpan.fromJson(Map<String, dynamic> json) =>
      _$SelectionSpanFromJson(json);
}
