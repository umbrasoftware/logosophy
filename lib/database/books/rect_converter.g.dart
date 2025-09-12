// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rect_converter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SerializablePdfTextLine _$SerializablePdfTextLineFromJson(
  Map<String, dynamic> json,
) => _SerializablePdfTextLine(
  text: json['text'] as String,
  bounds: const RectConverter().fromJson(
    json['bounds'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SerializablePdfTextLineToJson(
  _SerializablePdfTextLine instance,
) => <String, dynamic>{
  'text': instance.text,
  'bounds': const RectConverter().toJson(instance.bounds),
};
