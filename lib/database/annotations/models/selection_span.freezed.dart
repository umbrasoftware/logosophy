// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selection_span.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SelectionSpan {

 List<SerializablePdfTextLine> get textLines; String get type; int get pageNumber; int get color; double get opacity;
/// Create a copy of SelectionSpan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectionSpanCopyWith<SelectionSpan> get copyWith => _$SelectionSpanCopyWithImpl<SelectionSpan>(this as SelectionSpan, _$identity);

  /// Serializes this SelectionSpan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectionSpan&&const DeepCollectionEquality().equals(other.textLines, textLines)&&(identical(other.type, type) || other.type == type)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.color, color) || other.color == color)&&(identical(other.opacity, opacity) || other.opacity == opacity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(textLines),type,pageNumber,color,opacity);

@override
String toString() {
  return 'SelectionSpan(textLines: $textLines, type: $type, pageNumber: $pageNumber, color: $color, opacity: $opacity)';
}


}

/// @nodoc
abstract mixin class $SelectionSpanCopyWith<$Res>  {
  factory $SelectionSpanCopyWith(SelectionSpan value, $Res Function(SelectionSpan) _then) = _$SelectionSpanCopyWithImpl;
@useResult
$Res call({
 List<SerializablePdfTextLine> textLines, String type, int pageNumber, int color, double opacity
});




}
/// @nodoc
class _$SelectionSpanCopyWithImpl<$Res>
    implements $SelectionSpanCopyWith<$Res> {
  _$SelectionSpanCopyWithImpl(this._self, this._then);

  final SelectionSpan _self;
  final $Res Function(SelectionSpan) _then;

/// Create a copy of SelectionSpan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? textLines = null,Object? type = null,Object? pageNumber = null,Object? color = null,Object? opacity = null,}) {
  return _then(_self.copyWith(
textLines: null == textLines ? _self.textLines : textLines // ignore: cast_nullable_to_non_nullable
as List<SerializablePdfTextLine>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectionSpan].
extension SelectionSpanPatterns on SelectionSpan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectionSpan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectionSpan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectionSpan value)  $default,){
final _that = this;
switch (_that) {
case _SelectionSpan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectionSpan value)?  $default,){
final _that = this;
switch (_that) {
case _SelectionSpan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SerializablePdfTextLine> textLines,  String type,  int pageNumber,  int color,  double opacity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectionSpan() when $default != null:
return $default(_that.textLines,_that.type,_that.pageNumber,_that.color,_that.opacity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SerializablePdfTextLine> textLines,  String type,  int pageNumber,  int color,  double opacity)  $default,) {final _that = this;
switch (_that) {
case _SelectionSpan():
return $default(_that.textLines,_that.type,_that.pageNumber,_that.color,_that.opacity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SerializablePdfTextLine> textLines,  String type,  int pageNumber,  int color,  double opacity)?  $default,) {final _that = this;
switch (_that) {
case _SelectionSpan() when $default != null:
return $default(_that.textLines,_that.type,_that.pageNumber,_that.color,_that.opacity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SelectionSpan implements SelectionSpan {
   _SelectionSpan({required final  List<SerializablePdfTextLine> textLines, required this.type, required this.pageNumber, required this.color, required this.opacity}): _textLines = textLines;
  factory _SelectionSpan.fromJson(Map<String, dynamic> json) => _$SelectionSpanFromJson(json);

 final  List<SerializablePdfTextLine> _textLines;
@override List<SerializablePdfTextLine> get textLines {
  if (_textLines is EqualUnmodifiableListView) return _textLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_textLines);
}

@override final  String type;
@override final  int pageNumber;
@override final  int color;
@override final  double opacity;

/// Create a copy of SelectionSpan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectionSpanCopyWith<_SelectionSpan> get copyWith => __$SelectionSpanCopyWithImpl<_SelectionSpan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SelectionSpanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectionSpan&&const DeepCollectionEquality().equals(other._textLines, _textLines)&&(identical(other.type, type) || other.type == type)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.color, color) || other.color == color)&&(identical(other.opacity, opacity) || other.opacity == opacity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_textLines),type,pageNumber,color,opacity);

@override
String toString() {
  return 'SelectionSpan(textLines: $textLines, type: $type, pageNumber: $pageNumber, color: $color, opacity: $opacity)';
}


}

/// @nodoc
abstract mixin class _$SelectionSpanCopyWith<$Res> implements $SelectionSpanCopyWith<$Res> {
  factory _$SelectionSpanCopyWith(_SelectionSpan value, $Res Function(_SelectionSpan) _then) = __$SelectionSpanCopyWithImpl;
@override @useResult
$Res call({
 List<SerializablePdfTextLine> textLines, String type, int pageNumber, int color, double opacity
});




}
/// @nodoc
class __$SelectionSpanCopyWithImpl<$Res>
    implements _$SelectionSpanCopyWith<$Res> {
  __$SelectionSpanCopyWithImpl(this._self, this._then);

  final _SelectionSpan _self;
  final $Res Function(_SelectionSpan) _then;

/// Create a copy of SelectionSpan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? textLines = null,Object? type = null,Object? pageNumber = null,Object? color = null,Object? opacity = null,}) {
  return _then(_SelectionSpan(
textLines: null == textLines ? _self._textLines : textLines // ignore: cast_nullable_to_non_nullable
as List<SerializablePdfTextLine>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
