// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_annotations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PageAnnotations _$PageAnnotationsFromJson(Map<String, dynamic> json) =>
    _PageAnnotations(
      page: (json['page'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => SelectionSpan.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
    );

Map<String, dynamic> _$PageAnnotationsToJson(_PageAnnotations instance) =>
    <String, dynamic>{
      'page': instance.page.map(
        (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
      ),
    };
