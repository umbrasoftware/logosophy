// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryAdapter extends TypeAdapter<History> {
  @override
  final typeId = 1;

  @override
  History read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return History(
      query: fields[0] as String,
      timestamp: fields[1] as DateTime,
      results: fields[2] == null
          ? []
          : (fields[2] as List).cast<SearchResult>(),
      wasFiltered: fields[3] == null ? false : fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, History obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.query)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.results)
      ..writeByte(3)
      ..write(obj.wasFiltered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_History _$HistoryFromJson(Map<String, dynamic> json) => _History(
  query: json['query'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  results:
      (json['results'] as List<dynamic>?)
          ?.map((e) => SearchResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  wasFiltered: json['wasFiltered'] as bool? ?? false,
);

Map<String, dynamic> _$HistoryToJson(_History instance) => <String, dynamic>{
  'query': instance.query,
  'timestamp': instance.timestamp.toIso8601String(),
  'results': instance.results.map((e) => e.toJson()).toList(),
  'wasFiltered': instance.wasFiltered,
};
