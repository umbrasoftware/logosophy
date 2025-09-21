import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logosophy/database/notes/models/timestamp_converter.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
abstract class Note with _$Note {
  factory Note({
    required String id,
    String? bookId,
    int? page,
    required String note,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() required DateTime? updatedAt,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
