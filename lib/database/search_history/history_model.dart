import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:logosophy/database/search_history/search_model.dart';

part 'history_model.freezed.dart';
part 'history_model.g.dart';

@freezed
@HiveType(typeId: 1)
abstract class History with _$History {
  factory History({
    @HiveField(0) required final String query,
    @HiveField(1) required final DateTime timestamp,
    @HiveField(2) @Default([]) final List<SearchResult> results,
    @HiveField(3) @Default(false) final bool wasFiltered,
  }) = _History;

  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);
}
