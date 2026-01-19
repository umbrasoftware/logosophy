import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@freezed
@HiveType(typeId: 0)
abstract class BookData with _$BookData {
  factory BookData({
    @HiveField(0) required final String bookId,
    @HiveField(1) required final String coverPath,
    @HiveField(2) required final String bookPath,
    @HiveField(3) required final String title,
    @HiveField(4) required final DateTime lastOpened,
    @HiveField(5) required final double x,
    @HiveField(6) required final double y,
    @HiveField(7) required final double zoom,
  }) = _BookData;

  factory BookData.fromJson(Map<String, dynamic> json) => _$BookDataFromJson(json);
}
