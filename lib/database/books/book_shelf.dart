import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logosophy/database/books/book.dart';

part 'book_shelf.freezed.dart';
part 'book_shelf.g.dart';

@freezed
abstract class BookShelf with _$BookShelf {
  factory BookShelf({required String shelfId, required List<Book> books}) =
      _BookShelf;

  factory BookShelf.fromJson(Map<String, dynamic> json) =>
      _$BookShelfFromJson(json);
}
