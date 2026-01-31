// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookDataAdapter extends TypeAdapter<BookData> {
  @override
  final typeId = 0;

  @override
  BookData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookData(
      bookId: fields[0] as String,
      coverPath: fields[1] as String,
      bookPath: fields[2] as String,
      title: fields[3] as String,
      lastOpened: fields[4] as DateTime,
      x: (fields[5] as num).toDouble(),
      y: (fields[6] as num).toDouble(),
      zoom: (fields[7] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, BookData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.bookId)
      ..writeByte(1)
      ..write(obj.coverPath)
      ..writeByte(2)
      ..write(obj.bookPath)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.lastOpened)
      ..writeByte(5)
      ..write(obj.x)
      ..writeByte(6)
      ..write(obj.y)
      ..writeByte(7)
      ..write(obj.zoom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookData _$BookDataFromJson(Map<String, dynamic> json) => _BookData(
  bookId: json['bookId'] as String,
  coverPath: json['coverPath'] as String,
  bookPath: json['bookPath'] as String,
  title: json['title'] as String,
  lastOpened: DateTime.parse(json['lastOpened'] as String),
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  zoom: (json['zoom'] as num).toDouble(),
);

Map<String, dynamic> _$BookDataToJson(_BookData instance) => <String, dynamic>{
  'bookId': instance.bookId,
  'coverPath': instance.coverPath,
  'bookPath': instance.bookPath,
  'title': instance.title,
  'lastOpened': instance.lastOpened.toIso8601String(),
  'x': instance.x,
  'y': instance.y,
  'zoom': instance.zoom,
};
