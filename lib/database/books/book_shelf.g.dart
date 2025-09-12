// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_shelf.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookShelf _$BookShelfFromJson(Map<String, dynamic> json) => _BookShelf(
  shelfId: json['shelfId'] as String,
  books: (json['books'] as List<dynamic>)
      .map((e) => Book.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BookShelfToJson(_BookShelf instance) =>
    <String, dynamic>{
      'shelfId': instance.shelfId,
      'books': instance.books.map((e) => e.toJson()).toList(),
    };
