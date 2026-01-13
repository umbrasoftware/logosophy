// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_History _$HistoryFromJson(Map<String, dynamic> json) => _History(
  query: json['query'] as String,
  timestamp: json['timestamp'] as String,
  results:
      (json['results'] as List<dynamic>?)
          ?.map((e) => SearchResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$HistoryToJson(_History instance) => <String, dynamic>{
  'query': instance.query,
  'timestamp': instance.timestamp,
  'results': instance.results.map((e) => e.toJson()).toList(),
};
