// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchResult _$SearchResultFromJson(Map<String, dynamic> json) =>
    _SearchResult(
      similarity: (json['similarity'] as num).toDouble(),
      content: json['content'] as String,
      page: (_readFromMetadata(json, 'page') as num).toInt(),
      bookId: _readFromMetadata(json, 'book_id') as String,
    );

Map<String, dynamic> _$SearchResultToJson(_SearchResult instance) =>
    <String, dynamic>{
      'similarity': instance.similarity,
      'content': instance.content,
      'page': instance.page,
      'book_id': instance.bookId,
    };
