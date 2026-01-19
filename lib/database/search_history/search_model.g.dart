// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchResultAdapter extends TypeAdapter<SearchResult> {
  @override
  final typeId = 2;

  @override
  SearchResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchResult(
      similarity: (fields[0] as num).toDouble(),
      content: fields[1] as String,
      page: (fields[2] as num).toInt(),
      bookId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SearchResult obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.similarity)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.page)
      ..writeByte(3)
      ..write(obj.bookId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
