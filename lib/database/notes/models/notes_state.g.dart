// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotesState _$NotesStateFromJson(Map<String, dynamic> json) => _NotesState(
  notes: (json['notes'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, Note.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$NotesStateToJson(_NotesState instance) =>
    <String, dynamic>{
      'notes': instance.notes.map((k, e) => MapEntry(k, e.toJson())),
    };
