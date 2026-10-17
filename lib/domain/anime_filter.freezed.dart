// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anime_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnimeFilter {

 AnimeRegion get region; AnimeFormat get format; String? get genre;/// Zero includes every year; -1 includes releases before 2000.
 int get year; AnimeSort get sort;
/// Create a copy of AnimeFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnimeFilterCopyWith<AnimeFilter> get copyWith => _$AnimeFilterCopyWithImpl<AnimeFilter>(this as AnimeFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AnimeFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnimeFilter&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.format, _this.format) || other.format == _this.format)&&(identical(other.genre, _this.genre) || other.genre == _this.genre)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.sort, _this.sort) || other.sort == _this.sort));
}


@override
int get hashCode {
  final _this = this as AnimeFilter;
  return Object.hash(runtimeType,_this.region,_this.format,_this.genre,_this.year,_this.sort);
}

@override
String toString() {
  final _this = this as AnimeFilter;
  return 'AnimeFilter(region: ${_this.region}, format: ${_this.format}, genre: ${_this.genre}, year: ${_this.year}, sort: ${_this.sort})';
}


}

/// @nodoc
abstract mixin class $AnimeFilterCopyWith<$Res>  {
  factory $AnimeFilterCopyWith(AnimeFilter value, $Res Function(AnimeFilter) _then) = _$AnimeFilterCopyWithImpl;
@useResult
$Res call({
 AnimeRegion region, AnimeFormat format, String? genre, int year, AnimeSort sort
});




}
/// @nodoc
class _$AnimeFilterCopyWithImpl<$Res>
    implements $AnimeFilterCopyWith<$Res> {
  _$AnimeFilterCopyWithImpl(this._self, this._then);

  final AnimeFilter _self;
  final $Res Function(AnimeFilter) _then;

/// Create a copy of AnimeFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? region = null,Object? format = null,Object? genre = freezed,Object? year = null,Object? sort = null,}) {
  return _then(AnimeFilter(
region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as AnimeRegion,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as AnimeFormat,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as AnimeSort,
  ));
}

}


/// Adds pattern-matching-related methods to [AnimeFilter].
extension AnimeFilterPatterns on AnimeFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnimeFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnimeFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnimeFilter value)  $default,){
final _that = this;
switch (_that) {
case _AnimeFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnimeFilter value)?  $default,){
final _that = this;
switch (_that) {
case _AnimeFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnimeRegion region,  AnimeFormat format,  String? genre,  int year,  AnimeSort sort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnimeFilter() when $default != null:
return $default(_that.region,_that.format,_that.genre,_that.year,_that.sort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnimeRegion region,  AnimeFormat format,  String? genre,  int year,  AnimeSort sort)  $default,) {final _that = this;
switch (_that) {
case _AnimeFilter():
return $default(_that.region,_that.format,_that.genre,_that.year,_that.sort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnimeRegion region,  AnimeFormat format,  String? genre,  int year,  AnimeSort sort)?  $default,) {final _that = this;
switch (_that) {
case _AnimeFilter() when $default != null:
return $default(_that.region,_that.format,_that.genre,_that.year,_that.sort);case _:
  return null;

}
}

}

/// @nodoc


class _AnimeFilter implements AnimeFilter {
  const _AnimeFilter({this.region = AnimeRegion.all, this.format = AnimeFormat.all, this.genre, this.year = 0, this.sort = AnimeSort.rank});
  

@override@JsonKey() final  AnimeRegion region;
@override@JsonKey() final  AnimeFormat format;
@override final  String? genre;
/// Zero includes every year; -1 includes releases before 2000.
@override@JsonKey() final  int year;
@override@JsonKey() final  AnimeSort sort;

/// Create a copy of AnimeFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnimeFilterCopyWith<_AnimeFilter> get copyWith => __$AnimeFilterCopyWithImpl<_AnimeFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnimeFilter&&(identical(other.region, region) || other.region == region)&&(identical(other.format, format) || other.format == format)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.year, year) || other.year == year)&&(identical(other.sort, sort) || other.sort == sort));
}


@override
int get hashCode {
    return Object.hash(runtimeType,region,format,genre,year,sort);
}

@override
String toString() {
    return 'AnimeFilter(region: $region, format: $format, genre: $genre, year: $year, sort: $sort)';
}


}

/// @nodoc
abstract mixin class _$AnimeFilterCopyWith<$Res> implements $AnimeFilterCopyWith<$Res> {
  factory _$AnimeFilterCopyWith(_AnimeFilter value, $Res Function(_AnimeFilter) _then) = __$AnimeFilterCopyWithImpl;
@override @useResult
$Res call({
 AnimeRegion region, AnimeFormat format, String? genre, int year, AnimeSort sort
});




}
/// @nodoc
class __$AnimeFilterCopyWithImpl<$Res>
    implements _$AnimeFilterCopyWith<$Res> {
  __$AnimeFilterCopyWithImpl(this._self, this._then);

  final _AnimeFilter _self;
  final $Res Function(_AnimeFilter) _then;

/// Create a copy of AnimeFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? region = null,Object? format = null,Object? genre = freezed,Object? year = null,Object? sort = null,}) {
  return _then(_AnimeFilter(
region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as AnimeRegion,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as AnimeFormat,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as AnimeSort,
  ));
}


}

// dart format on
