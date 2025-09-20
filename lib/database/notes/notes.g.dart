// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Notes _$NotesFromJson(Map<String, dynamic> json) => _Notes(
  time: DateTime.parse(json['time'] as String),
  bookId: json['bookId'] as String,
  page: (json['page'] as num).toInt(),
  note: json['note'] as String,
);

Map<String, dynamic> _$NotesToJson(_Notes instance) => <String, dynamic>{
  'time': instance.time.toIso8601String(),
  'bookId': instance.bookId,
  'page': instance.page,
  'note': instance.note,
};
