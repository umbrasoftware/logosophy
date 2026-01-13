// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_model.freezed.dart';
part 'search_model.g.dart';

Object? _readFromMetadata(Map<dynamic, dynamic> json, String key) {
  return json['metadata']?[key];
}

@freezed
abstract class SearchResult with _$SearchResult {
  factory SearchResult({
    required final double similarity,
    required final String content,
    @JsonKey(readValue: _readFromMetadata) required final int page,
    @JsonKey(name: 'book_id', readValue: _readFromMetadata) required final String bookId,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
}
