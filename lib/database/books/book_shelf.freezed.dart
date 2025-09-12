// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_shelf.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookShelf {

 String get shelfId; List<Book> get books;
/// Create a copy of BookShelf
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookShelfCopyWith<BookShelf> get copyWith => _$BookShelfCopyWithImpl<BookShelf>(this as BookShelf, _$identity);

  /// Serializes this BookShelf to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookShelf&&(identical(other.shelfId, shelfId) || other.shelfId == shelfId)&&const DeepCollectionEquality().equals(other.books, books));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shelfId,const DeepCollectionEquality().hash(books));

@override
String toString() {
  return 'BookShelf(shelfId: $shelfId, books: $books)';
}


}

/// @nodoc
abstract mixin class $BookShelfCopyWith<$Res>  {
  factory $BookShelfCopyWith(BookShelf value, $Res Function(BookShelf) _then) = _$BookShelfCopyWithImpl;
@useResult
$Res call({
 String shelfId, List<Book> books
});




}
/// @nodoc
class _$BookShelfCopyWithImpl<$Res>
    implements $BookShelfCopyWith<$Res> {
  _$BookShelfCopyWithImpl(this._self, this._then);

  final BookShelf _self;
  final $Res Function(BookShelf) _then;

/// Create a copy of BookShelf
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shelfId = null,Object? books = null,}) {
  return _then(_self.copyWith(
shelfId: null == shelfId ? _self.shelfId : shelfId // ignore: cast_nullable_to_non_nullable
as String,books: null == books ? _self.books : books // ignore: cast_nullable_to_non_nullable
as List<Book>,
  ));
}

}


/// Adds pattern-matching-related methods to [BookShelf].
extension BookShelfPatterns on BookShelf {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookShelf value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookShelf() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookShelf value)  $default,){
final _that = this;
switch (_that) {
case _BookShelf():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookShelf value)?  $default,){
final _that = this;
switch (_that) {
case _BookShelf() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String shelfId,  List<Book> books)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookShelf() when $default != null:
return $default(_that.shelfId,_that.books);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String shelfId,  List<Book> books)  $default,) {final _that = this;
switch (_that) {
case _BookShelf():
return $default(_that.shelfId,_that.books);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String shelfId,  List<Book> books)?  $default,) {final _that = this;
switch (_that) {
case _BookShelf() when $default != null:
return $default(_that.shelfId,_that.books);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookShelf implements BookShelf {
   _BookShelf({required this.shelfId, required final  List<Book> books}): _books = books;
  factory _BookShelf.fromJson(Map<String, dynamic> json) => _$BookShelfFromJson(json);

@override final  String shelfId;
 final  List<Book> _books;
@override List<Book> get books {
  if (_books is EqualUnmodifiableListView) return _books;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_books);
}


/// Create a copy of BookShelf
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookShelfCopyWith<_BookShelf> get copyWith => __$BookShelfCopyWithImpl<_BookShelf>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookShelfToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookShelf&&(identical(other.shelfId, shelfId) || other.shelfId == shelfId)&&const DeepCollectionEquality().equals(other._books, _books));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,shelfId,const DeepCollectionEquality().hash(_books));

@override
String toString() {
  return 'BookShelf(shelfId: $shelfId, books: $books)';
}


}

/// @nodoc
abstract mixin class _$BookShelfCopyWith<$Res> implements $BookShelfCopyWith<$Res> {
  factory _$BookShelfCopyWith(_BookShelf value, $Res Function(_BookShelf) _then) = __$BookShelfCopyWithImpl;
@override @useResult
$Res call({
 String shelfId, List<Book> books
});




}
/// @nodoc
class __$BookShelfCopyWithImpl<$Res>
    implements _$BookShelfCopyWith<$Res> {
  __$BookShelfCopyWithImpl(this._self, this._then);

  final _BookShelf _self;
  final $Res Function(_BookShelf) _then;

/// Create a copy of BookShelf
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shelfId = null,Object? books = null,}) {
  return _then(_BookShelf(
shelfId: null == shelfId ? _self.shelfId : shelfId // ignore: cast_nullable_to_non_nullable
as String,books: null == books ? _self._books : books // ignore: cast_nullable_to_non_nullable
as List<Book>,
  ));
}


}

// dart format on
