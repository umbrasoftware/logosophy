import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
@HiveType(typeId: 3)
abstract class Settings with _$Settings {
  factory Settings({@HiveField(0) required String language, @HiveField(1) @Default('system') String theme}) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
}
