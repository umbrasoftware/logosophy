import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

part 'rect_converter.freezed.dart';
part 'rect_converter.g.dart';

class RectConverter implements JsonConverter<Rect, Map<String, dynamic>> {
  const RectConverter();

  @override
  Rect fromJson(Map<String, dynamic> json) {
    return Rect.fromLTWH(
      json['left'] as double,
      json['top'] as double,
      json['width'] as double,
      json['height'] as double,
    );
  }

  @override
  Map<String, dynamic> toJson(Rect object) {
    return {
      'left': object.left,
      'top': object.top,
      'width': object.width,
      'height': object.height,
    };
  }
}

// 1. O nosso modelo serializável para PdfTextLine
@freezed
abstract class SerializablePdfTextLine with _$SerializablePdfTextLine {
  factory SerializablePdfTextLine({
    required String text,
    @RectConverter() required Rect bounds,
  }) = _SerializablePdfTextLine;

  factory SerializablePdfTextLine.fromJson(Map<String, dynamic> json) =>
      _$SerializablePdfTextLineFromJson(json);

  // Função auxiliar para criar a partir do objeto original
  factory SerializablePdfTextLine.fromPdfTextLine(PdfTextLine line) {
    return SerializablePdfTextLine(text: line.text, bounds: line.bounds);
  }
}
