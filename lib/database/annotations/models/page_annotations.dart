import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logosophy/database/annotations/models/selection_span.dart';

part 'page_annotations.freezed.dart';
part 'page_annotations.g.dart';

/// The list of all `Annotation` for a given page.
@freezed
abstract class PageAnnotations with _$PageAnnotations {
  factory PageAnnotations({required Map<String, List<SelectionSpan>> page}) =
      _PageAnnotations;

  factory PageAnnotations.fromJson(Map<String, dynamic> json) =>
      _$PageAnnotationsFromJson(json);
}
