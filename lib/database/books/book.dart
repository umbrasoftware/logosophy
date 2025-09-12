import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logosophy/database/books/notes.dart';
import 'package:logosophy/database/books/selection_span.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
abstract class Book with _$Book {
  factory Book({
    required String bookId,
    @Default({}) Map<String, List<Notes>> notes,
    @Default({}) Map<String, List<SelectionSpan>> selections,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
