// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selection_span.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SelectionSpan _$SelectionSpanFromJson(Map<String, dynamic> json) =>
    _SelectionSpan(
      textLines: (json['textLines'] as List<dynamic>)
          .map(
            (e) => SerializablePdfTextLine.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      type: json['type'] as String,
      pageNumber: (json['pageNumber'] as num).toInt(),
      color: (json['color'] as num).toInt(),
      opacity: (json['opacity'] as num).toDouble(),
    );

Map<String, dynamic> _$SelectionSpanToJson(_SelectionSpan instance) =>
    <String, dynamic>{
      'textLines': instance.textLines.map((e) => e.toJson()).toList(),
      'type': instance.type,
      'pageNumber': instance.pageNumber,
      'color': instance.color,
      'opacity': instance.opacity,
    };
