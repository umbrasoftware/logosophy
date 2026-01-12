// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchResult _$SearchResultFromJson(Map<String, dynamic> json) =>
    _SearchResult(
      score: (json['score'] as num).toDouble(),
      content: json['content'] as String,
      page: (json['page'] as num).toInt(),
      bookId: json['bookId'] as String,
      madeAt: json['madeAt'] as String?,
    );

Map<String, dynamic> _$SearchResultToJson(_SearchResult instance) =>
    <String, dynamic>{
      'score': instance.score,
      'content': instance.content,
      'page': instance.page,
      'bookId': instance.bookId,
      'madeAt': instance.madeAt,
    };
