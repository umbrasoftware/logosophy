// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'annotations_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnnotationsState {

 Map<String, PageAnnotations> get book;
/// Create a copy of AnnotationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnnotationsStateCopyWith<AnnotationsState> get copyWith => _$AnnotationsStateCopyWithImpl<AnnotationsState>(this as AnnotationsState, _$identity);

  /// Serializes this AnnotationsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnnotationsState&&const DeepCollectionEquality().equals(other.book, book));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(book));

@override
String toString() {
  return 'AnnotationsState(book: $book)';
}


}

/// @nodoc
abstract mixin class $AnnotationsStateCopyWith<$Res>  {
  factory $AnnotationsStateCopyWith(AnnotationsState value, $Res Function(AnnotationsState) _then) = _$AnnotationsStateCopyWithImpl;
@useResult
$Res call({
 Map<String, PageAnnotations> book
});




}
/// @nodoc
class _$AnnotationsStateCopyWithImpl<$Res>
    implements $AnnotationsStateCopyWith<$Res> {
  _$AnnotationsStateCopyWithImpl(this._self, this._then);

  final AnnotationsState _self;
  final $Res Function(AnnotationsState) _then;

/// Create a copy of AnnotationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? book = null,}) {
  return _then(_self.copyWith(
book: null == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as Map<String, PageAnnotations>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnnotationsState].
extension AnnotationsStatePatterns on AnnotationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnnotationsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnnotationsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnnotationsState value)  $default,){
final _that = this;
switch (_that) {
case _AnnotationsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnnotationsState value)?  $default,){
final _that = this;
switch (_that) {
case _AnnotationsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, PageAnnotations> book)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnnotationsState() when $default != null:
return $default(_that.book);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, PageAnnotations> book)  $default,) {final _that = this;
switch (_that) {
case _AnnotationsState():
return $default(_that.book);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, PageAnnotations> book)?  $default,) {final _that = this;
switch (_that) {
case _AnnotationsState() when $default != null:
return $default(_that.book);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnnotationsState implements AnnotationsState {
   _AnnotationsState({required final  Map<String, PageAnnotations> book}): _book = book;
  factory _AnnotationsState.fromJson(Map<String, dynamic> json) => _$AnnotationsStateFromJson(json);

 final  Map<String, PageAnnotations> _book;
@override Map<String, PageAnnotations> get book {
  if (_book is EqualUnmodifiableMapView) return _book;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_book);
}


/// Create a copy of AnnotationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnnotationsStateCopyWith<_AnnotationsState> get copyWith => __$AnnotationsStateCopyWithImpl<_AnnotationsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnnotationsStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnnotationsState&&const DeepCollectionEquality().equals(other._book, _book));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_book));

@override
String toString() {
  return 'AnnotationsState(book: $book)';
}


}

/// @nodoc
abstract mixin class _$AnnotationsStateCopyWith<$Res> implements $AnnotationsStateCopyWith<$Res> {
  factory _$AnnotationsStateCopyWith(_AnnotationsState value, $Res Function(_AnnotationsState) _then) = __$AnnotationsStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, PageAnnotations> book
});




}
/// @nodoc
class __$AnnotationsStateCopyWithImpl<$Res>
    implements _$AnnotationsStateCopyWith<$Res> {
  __$AnnotationsStateCopyWithImpl(this._self, this._then);

  final _AnnotationsState _self;
  final $Res Function(_AnnotationsState) _then;

/// Create a copy of AnnotationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? book = null,}) {
  return _then(_AnnotationsState(
book: null == book ? _self._book : book // ignore: cast_nullable_to_non_nullable
as Map<String, PageAnnotations>,
  ));
}


}

// dart format on
