import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logosophy/database/notes/models/note.dart';

part 'notes_state.freezed.dart';
part 'notes_state.g.dart';

@freezed
abstract class NotesState with _$NotesState {
  factory NotesState({required Map<String, Note> notes}) = _NotesState;

  factory NotesState.fromJson(Map<String, dynamic> json) =>
      _$NotesStateFromJson(json);
}
