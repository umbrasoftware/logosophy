// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Notes {

 DateTime get time; String get bookId; int get page; String get note;
/// Create a copy of Notes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotesCopyWith<Notes> get copyWith => _$NotesCopyWithImpl<Notes>(this as Notes, _$identity);

  /// Serializes this Notes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Notes&&(identical(other.time, time) || other.time == time)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.page, page) || other.page == page)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,bookId,page,note);

@override
String toString() {
  return 'Notes(time: $time, bookId: $bookId, page: $page, note: $note)';
}


}

/// @nodoc
abstract mixin class $NotesCopyWith<$Res>  {
  factory $NotesCopyWith(Notes value, $Res Function(Notes) _then) = _$NotesCopyWithImpl;
@useResult
$Res call({
 DateTime time, String bookId, int page, String note
});




}
/// @nodoc
class _$NotesCopyWithImpl<$Res>
    implements $NotesCopyWith<$Res> {
  _$NotesCopyWithImpl(this._self, this._then);

  final Notes _self;
  final $Res Function(Notes) _then;

/// Create a copy of Notes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? bookId = null,Object? page = null,Object? note = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Notes].
extension NotesPatterns on Notes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Notes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Notes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Notes value)  $default,){
final _that = this;
switch (_that) {
case _Notes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Notes value)?  $default,){
final _that = this;
switch (_that) {
case _Notes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  String bookId,  int page,  String note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Notes() when $default != null:
return $default(_that.time,_that.bookId,_that.page,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  String bookId,  int page,  String note)  $default,) {final _that = this;
switch (_that) {
case _Notes():
return $default(_that.time,_that.bookId,_that.page,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  String bookId,  int page,  String note)?  $default,) {final _that = this;
switch (_that) {
case _Notes() when $default != null:
return $default(_that.time,_that.bookId,_that.page,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Notes implements Notes {
   _Notes({required this.time, required this.bookId, required this.page, required this.note});
  factory _Notes.fromJson(Map<String, dynamic> json) => _$NotesFromJson(json);

@override final  DateTime time;
@override final  String bookId;
@override final  int page;
@override final  String note;

/// Create a copy of Notes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotesCopyWith<_Notes> get copyWith => __$NotesCopyWithImpl<_Notes>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Notes&&(identical(other.time, time) || other.time == time)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.page, page) || other.page == page)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,bookId,page,note);

@override
String toString() {
  return 'Notes(time: $time, bookId: $bookId, page: $page, note: $note)';
}


}

/// @nodoc
abstract mixin class _$NotesCopyWith<$Res> implements $NotesCopyWith<$Res> {
  factory _$NotesCopyWith(_Notes value, $Res Function(_Notes) _then) = __$NotesCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, String bookId, int page, String note
});




}
/// @nodoc
class __$NotesCopyWithImpl<$Res>
    implements _$NotesCopyWith<$Res> {
  __$NotesCopyWithImpl(this._self, this._then);

  final _Notes _self;
  final $Res Function(_Notes) _then;

/// Create a copy of Notes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? bookId = null,Object? page = null,Object? note = null,}) {
  return _then(_Notes(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
