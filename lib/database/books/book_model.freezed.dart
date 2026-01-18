// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookData {

@HiveField(0) String get bookId;@HiveField(1) String get coverPath;@HiveField(2) String get bookPath;@HiveField(3) String get title;@HiveField(4) DateTime get lastOpened;@HiveField(5) double get x;@HiveField(6) double get y;@HiveField(7) double get zoom;
/// Create a copy of BookData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookDataCopyWith<BookData> get copyWith => _$BookDataCopyWithImpl<BookData>(this as BookData, _$identity);

  /// Serializes this BookData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookData&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.bookPath, bookPath) || other.bookPath == bookPath)&&(identical(other.title, title) || other.title == title)&&(identical(other.lastOpened, lastOpened) || other.lastOpened == lastOpened)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.zoom, zoom) || other.zoom == zoom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookId,coverPath,bookPath,title,lastOpened,x,y,zoom);

@override
String toString() {
  return 'BookData(bookId: $bookId, coverPath: $coverPath, bookPath: $bookPath, title: $title, lastOpened: $lastOpened, x: $x, y: $y, zoom: $zoom)';
}


}

/// @nodoc
abstract mixin class $BookDataCopyWith<$Res>  {
  factory $BookDataCopyWith(BookData value, $Res Function(BookData) _then) = _$BookDataCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String bookId,@HiveField(1) String coverPath,@HiveField(2) String bookPath,@HiveField(3) String title,@HiveField(4) DateTime lastOpened,@HiveField(5) double x,@HiveField(6) double y,@HiveField(7) double zoom
});




}
/// @nodoc
class _$BookDataCopyWithImpl<$Res>
    implements $BookDataCopyWith<$Res> {
  _$BookDataCopyWithImpl(this._self, this._then);

  final BookData _self;
  final $Res Function(BookData) _then;

/// Create a copy of BookData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookId = null,Object? coverPath = null,Object? bookPath = null,Object? title = null,Object? lastOpened = null,Object? x = null,Object? y = null,Object? zoom = null,}) {
  return _then(_self.copyWith(
bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,coverPath: null == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String,bookPath: null == bookPath ? _self.bookPath : bookPath // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,lastOpened: null == lastOpened ? _self.lastOpened : lastOpened // ignore: cast_nullable_to_non_nullable
as DateTime,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,zoom: null == zoom ? _self.zoom : zoom // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BookData].
extension BookDataPatterns on BookData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookData value)  $default,){
final _that = this;
switch (_that) {
case _BookData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookData value)?  $default,){
final _that = this;
switch (_that) {
case _BookData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String bookId, @HiveField(1)  String coverPath, @HiveField(2)  String bookPath, @HiveField(3)  String title, @HiveField(4)  DateTime lastOpened, @HiveField(5)  double x, @HiveField(6)  double y, @HiveField(7)  double zoom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookData() when $default != null:
return $default(_that.bookId,_that.coverPath,_that.bookPath,_that.title,_that.lastOpened,_that.x,_that.y,_that.zoom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String bookId, @HiveField(1)  String coverPath, @HiveField(2)  String bookPath, @HiveField(3)  String title, @HiveField(4)  DateTime lastOpened, @HiveField(5)  double x, @HiveField(6)  double y, @HiveField(7)  double zoom)  $default,) {final _that = this;
switch (_that) {
case _BookData():
return $default(_that.bookId,_that.coverPath,_that.bookPath,_that.title,_that.lastOpened,_that.x,_that.y,_that.zoom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String bookId, @HiveField(1)  String coverPath, @HiveField(2)  String bookPath, @HiveField(3)  String title, @HiveField(4)  DateTime lastOpened, @HiveField(5)  double x, @HiveField(6)  double y, @HiveField(7)  double zoom)?  $default,) {final _that = this;
switch (_that) {
case _BookData() when $default != null:
return $default(_that.bookId,_that.coverPath,_that.bookPath,_that.title,_that.lastOpened,_that.x,_that.y,_that.zoom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookData implements BookData {
   _BookData({@HiveField(0) required this.bookId, @HiveField(1) required this.coverPath, @HiveField(2) required this.bookPath, @HiveField(3) required this.title, @HiveField(4) required this.lastOpened, @HiveField(5) required this.x, @HiveField(6) required this.y, @HiveField(7) required this.zoom});
  factory _BookData.fromJson(Map<String, dynamic> json) => _$BookDataFromJson(json);

@override@HiveField(0) final  String bookId;
@override@HiveField(1) final  String coverPath;
@override@HiveField(2) final  String bookPath;
@override@HiveField(3) final  String title;
@override@HiveField(4) final  DateTime lastOpened;
@override@HiveField(5) final  double x;
@override@HiveField(6) final  double y;
@override@HiveField(7) final  double zoom;

/// Create a copy of BookData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookDataCopyWith<_BookData> get copyWith => __$BookDataCopyWithImpl<_BookData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookData&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.bookPath, bookPath) || other.bookPath == bookPath)&&(identical(other.title, title) || other.title == title)&&(identical(other.lastOpened, lastOpened) || other.lastOpened == lastOpened)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.zoom, zoom) || other.zoom == zoom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookId,coverPath,bookPath,title,lastOpened,x,y,zoom);

@override
String toString() {
  return 'BookData(bookId: $bookId, coverPath: $coverPath, bookPath: $bookPath, title: $title, lastOpened: $lastOpened, x: $x, y: $y, zoom: $zoom)';
}


}

/// @nodoc
abstract mixin class _$BookDataCopyWith<$Res> implements $BookDataCopyWith<$Res> {
  factory _$BookDataCopyWith(_BookData value, $Res Function(_BookData) _then) = __$BookDataCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String bookId,@HiveField(1) String coverPath,@HiveField(2) String bookPath,@HiveField(3) String title,@HiveField(4) DateTime lastOpened,@HiveField(5) double x,@HiveField(6) double y,@HiveField(7) double zoom
});




}
/// @nodoc
class __$BookDataCopyWithImpl<$Res>
    implements _$BookDataCopyWith<$Res> {
  __$BookDataCopyWithImpl(this._self, this._then);

  final _BookData _self;
  final $Res Function(_BookData) _then;

/// Create a copy of BookData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookId = null,Object? coverPath = null,Object? bookPath = null,Object? title = null,Object? lastOpened = null,Object? x = null,Object? y = null,Object? zoom = null,}) {
  return _then(_BookData(
bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,coverPath: null == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String,bookPath: null == bookPath ? _self.bookPath : bookPath // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,lastOpened: null == lastOpened ? _self.lastOpened : lastOpened // ignore: cast_nullable_to_non_nullable
as DateTime,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,zoom: null == zoom ? _self.zoom : zoom // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
