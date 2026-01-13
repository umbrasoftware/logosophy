// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Settings _$SettingsFromJson(Map<String, dynamic> json) => _Settings(
  language: json['language'] as String? ?? '',
  theme: json['theme'] as String? ?? 'system',
  overrideBookState: json['overrideBookState'] as bool? ?? false,
);

Map<String, dynamic> _$SettingsToJson(_Settings instance) => <String, dynamic>{
  'language': instance.language,
  'theme': instance.theme,
  'overrideBookState': instance.overrideBookState,
};
