import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logosophy/pages/search_tab/search_model.dart';

part 'history_model.freezed.dart';
part 'history_model.g.dart';

@freezed
abstract class History with _$History {
  factory History({
    required final String query,
    required final String timestamp,
    @Default([]) final List<SearchResult> results,
  }) = _History;

  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);
}
