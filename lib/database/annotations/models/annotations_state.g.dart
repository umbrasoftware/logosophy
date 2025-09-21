// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotations_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnnotationsState _$AnnotationsStateFromJson(Map<String, dynamic> json) =>
    _AnnotationsState(
      book: (json['book'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, PageAnnotations.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$AnnotationsStateToJson(_AnnotationsState instance) =>
    <String, dynamic>{
      'book': instance.book.map((k, e) => MapEntry(k, e.toJson())),
    };
