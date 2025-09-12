// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rect_converter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SerializablePdfTextLine {

 String get text;@RectConverter() Rect get bounds;
/// Create a copy of SerializablePdfTextLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SerializablePdfTextLineCopyWith<SerializablePdfTextLine> get copyWith => _$SerializablePdfTextLineCopyWithImpl<SerializablePdfTextLine>(this as SerializablePdfTextLine, _$identity);

  /// Serializes this SerializablePdfTextLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SerializablePdfTextLine&&(identical(other.text, text) || other.text == text)&&(identical(other.bounds, bounds) || other.bounds == bounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,bounds);

@override
String toString() {
  return 'SerializablePdfTextLine(text: $text, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class $SerializablePdfTextLineCopyWith<$Res>  {
  factory $SerializablePdfTextLineCopyWith(SerializablePdfTextLine value, $Res Function(SerializablePdfTextLine) _then) = _$SerializablePdfTextLineCopyWithImpl;
@useResult
$Res call({
 String text,@RectConverter() Rect bounds
});




}
/// @nodoc
class _$SerializablePdfTextLineCopyWithImpl<$Res>
    implements $SerializablePdfTextLineCopyWith<$Res> {
  _$SerializablePdfTextLineCopyWithImpl(this._self, this._then);

  final SerializablePdfTextLine _self;
  final $Res Function(SerializablePdfTextLine) _then;

/// Create a copy of SerializablePdfTextLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? bounds = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,bounds: null == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as Rect,
  ));
}

}


/// Adds pattern-matching-related methods to [SerializablePdfTextLine].
extension SerializablePdfTextLinePatterns on SerializablePdfTextLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SerializablePdfTextLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SerializablePdfTextLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SerializablePdfTextLine value)  $default,){
final _that = this;
switch (_that) {
case _SerializablePdfTextLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SerializablePdfTextLine value)?  $default,){
final _that = this;
switch (_that) {
case _SerializablePdfTextLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text, @RectConverter()  Rect bounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SerializablePdfTextLine() when $default != null:
return $default(_that.text,_that.bounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text, @RectConverter()  Rect bounds)  $default,) {final _that = this;
switch (_that) {
case _SerializablePdfTextLine():
return $default(_that.text,_that.bounds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text, @RectConverter()  Rect bounds)?  $default,) {final _that = this;
switch (_that) {
case _SerializablePdfTextLine() when $default != null:
return $default(_that.text,_that.bounds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SerializablePdfTextLine implements SerializablePdfTextLine {
   _SerializablePdfTextLine({required this.text, @RectConverter() required this.bounds});
  factory _SerializablePdfTextLine.fromJson(Map<String, dynamic> json) => _$SerializablePdfTextLineFromJson(json);

@override final  String text;
@override@RectConverter() final  Rect bounds;

/// Create a copy of SerializablePdfTextLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SerializablePdfTextLineCopyWith<_SerializablePdfTextLine> get copyWith => __$SerializablePdfTextLineCopyWithImpl<_SerializablePdfTextLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SerializablePdfTextLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SerializablePdfTextLine&&(identical(other.text, text) || other.text == text)&&(identical(other.bounds, bounds) || other.bounds == bounds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,bounds);

@override
String toString() {
  return 'SerializablePdfTextLine(text: $text, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class _$SerializablePdfTextLineCopyWith<$Res> implements $SerializablePdfTextLineCopyWith<$Res> {
  factory _$SerializablePdfTextLineCopyWith(_SerializablePdfTextLine value, $Res Function(_SerializablePdfTextLine) _then) = __$SerializablePdfTextLineCopyWithImpl;
@override @useResult
$Res call({
 String text,@RectConverter() Rect bounds
});




}
/// @nodoc
class __$SerializablePdfTextLineCopyWithImpl<$Res>
    implements _$SerializablePdfTextLineCopyWith<$Res> {
  __$SerializablePdfTextLineCopyWithImpl(this._self, this._then);

  final _SerializablePdfTextLine _self;
  final $Res Function(_SerializablePdfTextLine) _then;

/// Create a copy of SerializablePdfTextLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? bounds = null,}) {
  return _then(_SerializablePdfTextLine(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,bounds: null == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as Rect,
  ));
}


}

// dart format on
