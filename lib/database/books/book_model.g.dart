// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookData _$BookDataFromJson(Map<String, dynamic> json) => _BookData(
  bookId: json['bookId'] as String,
  coverPath: json['coverPath'] as String,
  bookPath: json['bookPath'] as String,
  title: json['title'] as String,
  lastOpened: json['lastOpened'] as String,
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  zoom: (json['zoom'] as num).toDouble(),
);

Map<String, dynamic> _$BookDataToJson(_BookData instance) => <String, dynamic>{
  'bookId': instance.bookId,
  'coverPath': instance.coverPath,
  'bookPath': instance.bookPath,
  'title': instance.title,
  'lastOpened': instance.lastOpened,
  'x': instance.x,
  'y': instance.y,
  'zoom': instance.zoom,
};
