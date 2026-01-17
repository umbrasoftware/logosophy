import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@freezed
abstract class BookData with _$BookData {
  factory BookData({
    required final String bookId,
    required final String coverPath,
    required final String bookPath,
    required final String title,
    required final String lastOpened,
    required final double x,
    required final double y,
    required final double zoom,
  }) = _BookData;

  factory BookData.fromJson(Map<String, dynamic> json) => _$BookDataFromJson(json);
}
