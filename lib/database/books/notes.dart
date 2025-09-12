import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes.freezed.dart';
part 'notes.g.dart';

@freezed
abstract class Notes with _$Notes {
  factory Notes({
    required DateTime time,
    required int page,
    required String notes,
  }) = _Notes;

  factory Notes.fromJson(Map<String, dynamic> json) => _$NotesFromJson(json);
}
