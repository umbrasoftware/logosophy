import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result_class.freezed.dart';
part 'search_result_class.g.dart';

@freezed
abstract class SearchResult with _$SearchResult {
  factory SearchResult({
    required final double score,
    required final String content,
    required final int page,
    required final String bookId,
    final String? madeAt,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
}
