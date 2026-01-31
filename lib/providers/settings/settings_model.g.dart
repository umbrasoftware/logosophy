// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final typeId = 3;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      language: fields[0] as String,
      theme: fields[1] == null ? 'system' : fields[1] as String,
      fontSize: fields[2] == null ? 0.0 : (fields[2] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.theme)
      ..writeByte(2)
      ..write(obj.fontSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Settings _$SettingsFromJson(Map<String, dynamic> json) => _Settings(
  language: json['language'] as String,
  theme: json['theme'] as String? ?? 'system',
  fontSize: (json['fontSize'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$SettingsToJson(_Settings instance) => <String, dynamic>{
  'language': instance.language,
  'theme': instance.theme,
  'fontSize': instance.fontSize,
};
