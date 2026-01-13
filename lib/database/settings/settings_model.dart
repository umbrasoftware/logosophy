import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
abstract class Settings with _$Settings {
  factory Settings({
    @Default('') String language,
    @Default('system') String theme,
    @Default(false) bool overrideBookState,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
}
