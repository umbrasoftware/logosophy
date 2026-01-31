// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

part 'search_model.freezed.dart';
part 'search_model.g.dart';

Object? _readFromMetadata(Map<dynamic, dynamic> json, String key) {
  return json['metadata']?[key];
}

@freezed
@HiveType(typeId: 2)
abstract class SearchResult with _$SearchResult {
  factory SearchResult({
    @HiveField(0) required final double similarity,
    @HiveField(1) required final String content,
    @HiveField(2) @JsonKey(readValue: _readFromMetadata) required final int page,
    @HiveField(3) @JsonKey(name: 'book_id', readValue: _readFromMetadata) required final String bookId,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
}
