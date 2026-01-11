import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_class.freezed.dart';
part 'settings_class.g.dart';

@freezed
abstract class Settings with _$Settings {
  factory Settings({
    @Default('') String language,
    @Default('system') String theme,
    @Default(false) bool overrideBookState,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
}
