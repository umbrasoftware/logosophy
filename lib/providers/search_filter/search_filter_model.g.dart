// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchFilter _$SearchFilterFromJson(Map<String, dynamic> json) =>
    _SearchFilter(
      includeOnlyIds: (json['includeOnlyIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      excludeOnlyIds: (json['excludeOnlyIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SearchFilterToJson(_SearchFilter instance) =>
    <String, dynamic>{
      'includeOnlyIds': instance.includeOnlyIds,
      'excludeOnlyIds': instance.excludeOnlyIds,
    };
