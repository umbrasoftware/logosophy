import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

/// This is the type definition for an `Annotation` to be store in the Firebase.
@freezed
abstract class Settings with _$Settings {
  factory Settings({required String language}) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}
