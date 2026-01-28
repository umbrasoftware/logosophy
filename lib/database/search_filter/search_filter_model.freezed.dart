// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchFilter {

 List<String> get includeOnlyIds; List<String> get excludeOnlyIds;
/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFilterCopyWith<SearchFilter> get copyWith => _$SearchFilterCopyWithImpl<SearchFilter>(this as SearchFilter, _$identity);

  /// Serializes this SearchFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFilter&&const DeepCollectionEquality().equals(other.includeOnlyIds, includeOnlyIds)&&const DeepCollectionEquality().equals(other.excludeOnlyIds, excludeOnlyIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(includeOnlyIds),const DeepCollectionEquality().hash(excludeOnlyIds));

@override
String toString() {
  return 'SearchFilter(includeOnlyIds: $includeOnlyIds, excludeOnlyIds: $excludeOnlyIds)';
}


}

/// @nodoc
abstract mixin class $SearchFilterCopyWith<$Res>  {
  factory $SearchFilterCopyWith(SearchFilter value, $Res Function(SearchFilter) _then) = _$SearchFilterCopyWithImpl;
@useResult
$Res call({
 List<String> includeOnlyIds, List<String> excludeOnlyIds
});




}
/// @nodoc
class _$SearchFilterCopyWithImpl<$Res>
    implements $SearchFilterCopyWith<$Res> {
  _$SearchFilterCopyWithImpl(this._self, this._then);

  final SearchFilter _self;
  final $Res Function(SearchFilter) _then;

/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? includeOnlyIds = null,Object? excludeOnlyIds = null,}) {
  return _then(_self.copyWith(
includeOnlyIds: null == includeOnlyIds ? _self.includeOnlyIds : includeOnlyIds // ignore: cast_nullable_to_non_nullable
as List<String>,excludeOnlyIds: null == excludeOnlyIds ? _self.excludeOnlyIds : excludeOnlyIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchFilter].
extension SearchFilterPatterns on SearchFilter {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchFilter value)  $default,){
final _that = this;
switch (_that) {
case _SearchFilter():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchFilter value)?  $default,){
final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> includeOnlyIds,  List<String> excludeOnlyIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
return $default(_that.includeOnlyIds,_that.excludeOnlyIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> includeOnlyIds,  List<String> excludeOnlyIds)  $default,) {final _that = this;
switch (_that) {
case _SearchFilter():
return $default(_that.includeOnlyIds,_that.excludeOnlyIds);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> includeOnlyIds,  List<String> excludeOnlyIds)?  $default,) {final _that = this;
switch (_that) {
case _SearchFilter() when $default != null:
return $default(_that.includeOnlyIds,_that.excludeOnlyIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchFilter implements SearchFilter {
   _SearchFilter({required final  List<String> includeOnlyIds, required final  List<String> excludeOnlyIds}): _includeOnlyIds = includeOnlyIds,_excludeOnlyIds = excludeOnlyIds;
  factory _SearchFilter.fromJson(Map<String, dynamic> json) => _$SearchFilterFromJson(json);

 final  List<String> _includeOnlyIds;
@override List<String> get includeOnlyIds {
  if (_includeOnlyIds is EqualUnmodifiableListView) return _includeOnlyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_includeOnlyIds);
}

 final  List<String> _excludeOnlyIds;
@override List<String> get excludeOnlyIds {
  if (_excludeOnlyIds is EqualUnmodifiableListView) return _excludeOnlyIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_excludeOnlyIds);
}


/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchFilterCopyWith<_SearchFilter> get copyWith => __$SearchFilterCopyWithImpl<_SearchFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchFilter&&const DeepCollectionEquality().equals(other._includeOnlyIds, _includeOnlyIds)&&const DeepCollectionEquality().equals(other._excludeOnlyIds, _excludeOnlyIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_includeOnlyIds),const DeepCollectionEquality().hash(_excludeOnlyIds));

@override
String toString() {
  return 'SearchFilter(includeOnlyIds: $includeOnlyIds, excludeOnlyIds: $excludeOnlyIds)';
}


}

/// @nodoc
abstract mixin class _$SearchFilterCopyWith<$Res> implements $SearchFilterCopyWith<$Res> {
  factory _$SearchFilterCopyWith(_SearchFilter value, $Res Function(_SearchFilter) _then) = __$SearchFilterCopyWithImpl;
@override @useResult
$Res call({
 List<String> includeOnlyIds, List<String> excludeOnlyIds
});




}
/// @nodoc
class __$SearchFilterCopyWithImpl<$Res>
    implements _$SearchFilterCopyWith<$Res> {
  __$SearchFilterCopyWithImpl(this._self, this._then);

  final _SearchFilter _self;
  final $Res Function(_SearchFilter) _then;

/// Create a copy of SearchFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? includeOnlyIds = null,Object? excludeOnlyIds = null,}) {
  return _then(_SearchFilter(
includeOnlyIds: null == includeOnlyIds ? _self._includeOnlyIds : includeOnlyIds // ignore: cast_nullable_to_non_nullable
as List<String>,excludeOnlyIds: null == excludeOnlyIds ? _self._excludeOnlyIds : excludeOnlyIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
