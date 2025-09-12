// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Book _$BookFromJson(Map<String, dynamic> json) => _Book(
  bookId: json['bookId'] as String,
  notes:
      (json['notes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => Notes.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ) ??
      const {},
  selections:
      (json['selections'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => SelectionSpan.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ) ??
      const {},
);

Map<String, dynamic> _$BookToJson(_Book instance) => <String, dynamic>{
  'bookId': instance.bookId,
  'notes': instance.notes.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'selections': instance.selections.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
};
