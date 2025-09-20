// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_annotations.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PageAnnotations {

 Map<String, List<SelectionSpan>> get page;
/// Create a copy of PageAnnotations
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PageAnnotationsCopyWith<PageAnnotations> get copyWith => _$PageAnnotationsCopyWithImpl<PageAnnotations>(this as PageAnnotations, _$identity);

  /// Serializes this PageAnnotations to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PageAnnotations&&const DeepCollectionEquality().equals(other.page, page));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(page));

@override
String toString() {
  return 'PageAnnotations(page: $page)';
}


}

/// @nodoc
abstract mixin class $PageAnnotationsCopyWith<$Res>  {
  factory $PageAnnotationsCopyWith(PageAnnotations value, $Res Function(PageAnnotations) _then) = _$PageAnnotationsCopyWithImpl;
@useResult
$Res call({
 Map<String, List<SelectionSpan>> page
});




}
/// @nodoc
class _$PageAnnotationsCopyWithImpl<$Res>
    implements $PageAnnotationsCopyWith<$Res> {
  _$PageAnnotationsCopyWithImpl(this._self, this._then);

  final PageAnnotations _self;
  final $Res Function(PageAnnotations) _then;

/// Create a copy of PageAnnotations
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as Map<String, List<SelectionSpan>>,
  ));
}

}


/// Adds pattern-matching-related methods to [PageAnnotations].
extension PageAnnotationsPatterns on PageAnnotations {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PageAnnotations value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PageAnnotations() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PageAnnotations value)  $default,){
final _that = this;
switch (_that) {
case _PageAnnotations():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PageAnnotations value)?  $default,){
final _that = this;
switch (_that) {
case _PageAnnotations() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, List<SelectionSpan>> page)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PageAnnotations() when $default != null:
return $default(_that.page);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, List<SelectionSpan>> page)  $default,) {final _that = this;
switch (_that) {
case _PageAnnotations():
return $default(_that.page);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, List<SelectionSpan>> page)?  $default,) {final _that = this;
switch (_that) {
case _PageAnnotations() when $default != null:
return $default(_that.page);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PageAnnotations implements PageAnnotations {
   _PageAnnotations({required final  Map<String, List<SelectionSpan>> page}): _page = page;
  factory _PageAnnotations.fromJson(Map<String, dynamic> json) => _$PageAnnotationsFromJson(json);

 final  Map<String, List<SelectionSpan>> _page;
@override Map<String, List<SelectionSpan>> get page {
  if (_page is EqualUnmodifiableMapView) return _page;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_page);
}


/// Create a copy of PageAnnotations
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PageAnnotationsCopyWith<_PageAnnotations> get copyWith => __$PageAnnotationsCopyWithImpl<_PageAnnotations>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PageAnnotationsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PageAnnotations&&const DeepCollectionEquality().equals(other._page, _page));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_page));

@override
String toString() {
  return 'PageAnnotations(page: $page)';
}


}

/// @nodoc
abstract mixin class _$PageAnnotationsCopyWith<$Res> implements $PageAnnotationsCopyWith<$Res> {
  factory _$PageAnnotationsCopyWith(_PageAnnotations value, $Res Function(_PageAnnotations) _then) = __$PageAnnotationsCopyWithImpl;
@override @useResult
$Res call({
 Map<String, List<SelectionSpan>> page
});




}
/// @nodoc
class __$PageAnnotationsCopyWithImpl<$Res>
    implements _$PageAnnotationsCopyWith<$Res> {
  __$PageAnnotationsCopyWithImpl(this._self, this._then);

  final _PageAnnotations _self;
  final $Res Function(_PageAnnotations) _then;

/// Create a copy of PageAnnotations
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,}) {
  return _then(_PageAnnotations(
page: null == page ? _self._page : page // ignore: cast_nullable_to_non_nullable
as Map<String, List<SelectionSpan>>,
  ));
}


}

// dart format on
