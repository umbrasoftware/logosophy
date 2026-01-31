import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filter_model.freezed.dart';
part 'search_filter_model.g.dart';

@freezed
abstract class SearchFilter with _$SearchFilter {
  factory SearchFilter({required final List<String> includeOnlyIds, required final List<String> excludeOnlyIds}) =
      _SearchFilter;

  factory SearchFilter.fromJson(Map<String, dynamic> json) => _$SearchFilterFromJson(json);
}
