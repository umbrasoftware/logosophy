import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logosophy/database/annotations/models/page_annotations.dart';

part 'annotations_state.freezed.dart';
part 'annotations_state.g.dart';

@freezed
abstract class AnnotationsState with _$AnnotationsState {
  factory AnnotationsState({required Map<String, PageAnnotations> book}) =
      _AnnotationsState;

  factory AnnotationsState.fromJson(Map<String, dynamic> json) =>
      _$AnnotationsStateFromJson(json);
}
