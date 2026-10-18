// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bangumi_discovery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrowseQuery {

 BrowseMode get mode; int get year; int get quarter; BrowseOrder get order; BrowseFormat get format;
/// Create a copy of BrowseQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrowseQueryCopyWith<BrowseQuery> get copyWith => _$BrowseQueryCopyWithImpl<BrowseQuery>(this as BrowseQuery, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BrowseQuery;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowseQuery&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.quarter, _this.quarter) || other.quarter == _this.quarter)&&(identical(other.order, _this.order) || other.order == _this.order)&&(identical(other.format, _this.format) || other.format == _this.format));
}


@override
int get hashCode {
  final _this = this as BrowseQuery;
  return Object.hash(runtimeType,_this.mode,_this.year,_this.quarter,_this.order,_this.format);
}

@override
String toString() {
  final _this = this as BrowseQuery;
  return 'BrowseQuery(mode: ${_this.mode}, year: ${_this.year}, quarter: ${_this.quarter}, order: ${_this.order}, format: ${_this.format})';
}


}

/// @nodoc
abstract mixin class $BrowseQueryCopyWith<$Res>  {
  factory $BrowseQueryCopyWith(BrowseQuery value, $Res Function(BrowseQuery) _then) = _$BrowseQueryCopyWithImpl;
@useResult
$Res call({
 BrowseMode mode, int year, int quarter, BrowseOrder order, BrowseFormat format
});




}
/// @nodoc
class _$BrowseQueryCopyWithImpl<$Res>
    implements $BrowseQueryCopyWith<$Res> {
  _$BrowseQueryCopyWithImpl(this._self, this._then);

  final BrowseQuery _self;
  final $Res Function(BrowseQuery) _then;

/// Create a copy of BrowseQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? year = null,Object? quarter = null,Object? order = null,Object? format = null,}) {
  return _then(BrowseQuery(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as BrowseMode,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,quarter: null == quarter ? _self.quarter : quarter // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as BrowseOrder,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BrowseFormat,
  ));
}

}


/// Adds pattern-matching-related methods to [BrowseQuery].
extension BrowseQueryPatterns on BrowseQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrowseQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrowseQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrowseQuery value)  $default,){
final _that = this;
switch (_that) {
case _BrowseQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrowseQuery value)?  $default,){
final _that = this;
switch (_that) {
case _BrowseQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BrowseMode mode,  int year,  int quarter,  BrowseOrder order,  BrowseFormat format)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrowseQuery() when $default != null:
return $default(_that.mode,_that.year,_that.quarter,_that.order,_that.format);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BrowseMode mode,  int year,  int quarter,  BrowseOrder order,  BrowseFormat format)  $default,) {final _that = this;
switch (_that) {
case _BrowseQuery():
return $default(_that.mode,_that.year,_that.quarter,_that.order,_that.format);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BrowseMode mode,  int year,  int quarter,  BrowseOrder order,  BrowseFormat format)?  $default,) {final _that = this;
switch (_that) {
case _BrowseQuery() when $default != null:
return $default(_that.mode,_that.year,_that.quarter,_that.order,_that.format);case _:
  return null;

}
}

}

/// @nodoc


class _BrowseQuery implements BrowseQuery {
  const _BrowseQuery({this.mode = BrowseMode.season, this.year = 0, this.quarter = 1, this.order = BrowseOrder.heat, this.format = BrowseFormat.all});
  

@override@JsonKey() final  BrowseMode mode;
@override@JsonKey() final  int year;
@override@JsonKey() final  int quarter;
@override@JsonKey() final  BrowseOrder order;
@override@JsonKey() final  BrowseFormat format;

/// Create a copy of BrowseQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrowseQueryCopyWith<_BrowseQuery> get copyWith => __$BrowseQueryCopyWithImpl<_BrowseQuery>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrowseQuery&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.year, year) || other.year == year)&&(identical(other.quarter, quarter) || other.quarter == quarter)&&(identical(other.order, order) || other.order == order)&&(identical(other.format, format) || other.format == format));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,year,quarter,order,format);
}

@override
String toString() {
    return 'BrowseQuery(mode: $mode, year: $year, quarter: $quarter, order: $order, format: $format)';
}


}

/// @nodoc
abstract mixin class _$BrowseQueryCopyWith<$Res> implements $BrowseQueryCopyWith<$Res> {
  factory _$BrowseQueryCopyWith(_BrowseQuery value, $Res Function(_BrowseQuery) _then) = __$BrowseQueryCopyWithImpl;
@override @useResult
$Res call({
 BrowseMode mode, int year, int quarter, BrowseOrder order, BrowseFormat format
});




}
/// @nodoc
class __$BrowseQueryCopyWithImpl<$Res>
    implements _$BrowseQueryCopyWith<$Res> {
  __$BrowseQueryCopyWithImpl(this._self, this._then);

  final _BrowseQuery _self;
  final $Res Function(_BrowseQuery) _then;

/// Create a copy of BrowseQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? year = null,Object? quarter = null,Object? order = null,Object? format = null,}) {
  return _then(_BrowseQuery(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as BrowseMode,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,quarter: null == quarter ? _self.quarter : quarter // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as BrowseOrder,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BrowseFormat,
  ));
}


}

/// @nodoc
mixin _$BroadcastDay {

 int get weekday; List<Anime> get items;
/// Create a copy of BroadcastDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BroadcastDayCopyWith<BroadcastDay> get copyWith => _$BroadcastDayCopyWithImpl<BroadcastDay>(this as BroadcastDay, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BroadcastDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BroadcastDay&&(identical(other.weekday, _this.weekday) || other.weekday == _this.weekday)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as BroadcastDay;
  return Object.hash(runtimeType,_this.weekday,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as BroadcastDay;
  return 'BroadcastDay(weekday: ${_this.weekday}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $BroadcastDayCopyWith<$Res>  {
  factory $BroadcastDayCopyWith(BroadcastDay value, $Res Function(BroadcastDay) _then) = _$BroadcastDayCopyWithImpl;
@useResult
$Res call({
 int weekday, List<Anime> items
});




}
/// @nodoc
class _$BroadcastDayCopyWithImpl<$Res>
    implements $BroadcastDayCopyWith<$Res> {
  _$BroadcastDayCopyWithImpl(this._self, this._then);

  final BroadcastDay _self;
  final $Res Function(BroadcastDay) _then;

/// Create a copy of BroadcastDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekday = null,Object? items = null,}) {
  return _then(BroadcastDay(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Anime>,
  ));
}

}


/// Adds pattern-matching-related methods to [BroadcastDay].
extension BroadcastDayPatterns on BroadcastDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BroadcastDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BroadcastDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BroadcastDay value)  $default,){
final _that = this;
switch (_that) {
case _BroadcastDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BroadcastDay value)?  $default,){
final _that = this;
switch (_that) {
case _BroadcastDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int weekday,  List<Anime> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BroadcastDay() when $default != null:
return $default(_that.weekday,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int weekday,  List<Anime> items)  $default,) {final _that = this;
switch (_that) {
case _BroadcastDay():
return $default(_that.weekday,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int weekday,  List<Anime> items)?  $default,) {final _that = this;
switch (_that) {
case _BroadcastDay() when $default != null:
return $default(_that.weekday,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _BroadcastDay implements BroadcastDay {
  const _BroadcastDay({required this.weekday,  List<Anime> items = const []}): _items = items;
  

@override final  int weekday;
 final  List<Anime> _items;
@override@JsonKey() List<Anime> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of BroadcastDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BroadcastDayCopyWith<_BroadcastDay> get copyWith => __$BroadcastDayCopyWithImpl<_BroadcastDay>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BroadcastDay&&(identical(other.weekday, weekday) || other.weekday == weekday)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,weekday,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'BroadcastDay(weekday: $weekday, items: $items)';
}


}

/// @nodoc
abstract mixin class _$BroadcastDayCopyWith<$Res> implements $BroadcastDayCopyWith<$Res> {
  factory _$BroadcastDayCopyWith(_BroadcastDay value, $Res Function(_BroadcastDay) _then) = __$BroadcastDayCopyWithImpl;
@override @useResult
$Res call({
 int weekday, List<Anime> items
});




}
/// @nodoc
class __$BroadcastDayCopyWithImpl<$Res>
    implements _$BroadcastDayCopyWith<$Res> {
  __$BroadcastDayCopyWithImpl(this._self, this._then);

  final _BroadcastDay _self;
  final $Res Function(_BroadcastDay) _then;

/// Create a copy of BroadcastDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekday = null,Object? items = null,}) {
  return _then(_BroadcastDay(
weekday: null == weekday ? _self.weekday : weekday // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Anime>,
  ));
}


}

/// @nodoc
mixin _$RelatedAnime {

 Anime get anime; String get relation;
/// Create a copy of RelatedAnime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelatedAnimeCopyWith<RelatedAnime> get copyWith => _$RelatedAnimeCopyWithImpl<RelatedAnime>(this as RelatedAnime, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RelatedAnime;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RelatedAnime&&(identical(other.anime, _this.anime) || other.anime == _this.anime)&&(identical(other.relation, _this.relation) || other.relation == _this.relation));
}


@override
int get hashCode {
  final _this = this as RelatedAnime;
  return Object.hash(runtimeType,_this.anime,_this.relation);
}

@override
String toString() {
  final _this = this as RelatedAnime;
  return 'RelatedAnime(anime: ${_this.anime}, relation: ${_this.relation})';
}


}

/// @nodoc
abstract mixin class $RelatedAnimeCopyWith<$Res>  {
  factory $RelatedAnimeCopyWith(RelatedAnime value, $Res Function(RelatedAnime) _then) = _$RelatedAnimeCopyWithImpl;
@useResult
$Res call({
 Anime anime, String relation
});


$AnimeCopyWith<$Res> get anime;

}
/// @nodoc
class _$RelatedAnimeCopyWithImpl<$Res>
    implements $RelatedAnimeCopyWith<$Res> {
  _$RelatedAnimeCopyWithImpl(this._self, this._then);

  final RelatedAnime _self;
  final $Res Function(RelatedAnime) _then;

/// Create a copy of RelatedAnime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anime = null,Object? relation = null,}) {
  return _then(RelatedAnime(
anime: null == anime ? _self.anime : anime // ignore: cast_nullable_to_non_nullable
as Anime,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of RelatedAnime
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnimeCopyWith<$Res> get anime {
  
  return $AnimeCopyWith<$Res>(_self.anime, (value) {
    return _then(_self.copyWith(anime: value));
  });
}
}


/// Adds pattern-matching-related methods to [RelatedAnime].
extension RelatedAnimePatterns on RelatedAnime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RelatedAnime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RelatedAnime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RelatedAnime value)  $default,){
final _that = this;
switch (_that) {
case _RelatedAnime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RelatedAnime value)?  $default,){
final _that = this;
switch (_that) {
case _RelatedAnime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Anime anime,  String relation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RelatedAnime() when $default != null:
return $default(_that.anime,_that.relation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Anime anime,  String relation)  $default,) {final _that = this;
switch (_that) {
case _RelatedAnime():
return $default(_that.anime,_that.relation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Anime anime,  String relation)?  $default,) {final _that = this;
switch (_that) {
case _RelatedAnime() when $default != null:
return $default(_that.anime,_that.relation);case _:
  return null;

}
}

}

/// @nodoc


class _RelatedAnime implements RelatedAnime {
  const _RelatedAnime({required this.anime, required this.relation});
  

@override final  Anime anime;
@override final  String relation;

/// Create a copy of RelatedAnime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RelatedAnimeCopyWith<_RelatedAnime> get copyWith => __$RelatedAnimeCopyWithImpl<_RelatedAnime>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RelatedAnime&&(identical(other.anime, anime) || other.anime == anime)&&(identical(other.relation, relation) || other.relation == relation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,anime,relation);
}

@override
String toString() {
    return 'RelatedAnime(anime: $anime, relation: $relation)';
}


}

/// @nodoc
abstract mixin class _$RelatedAnimeCopyWith<$Res> implements $RelatedAnimeCopyWith<$Res> {
  factory _$RelatedAnimeCopyWith(_RelatedAnime value, $Res Function(_RelatedAnime) _then) = __$RelatedAnimeCopyWithImpl;
@override @useResult
$Res call({
 Anime anime, String relation
});


@override $AnimeCopyWith<$Res> get anime;

}
/// @nodoc
class __$RelatedAnimeCopyWithImpl<$Res>
    implements _$RelatedAnimeCopyWith<$Res> {
  __$RelatedAnimeCopyWithImpl(this._self, this._then);

  final _RelatedAnime _self;
  final $Res Function(_RelatedAnime) _then;

/// Create a copy of RelatedAnime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anime = null,Object? relation = null,}) {
  return _then(_RelatedAnime(
anime: null == anime ? _self.anime : anime // ignore: cast_nullable_to_non_nullable
as Anime,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of RelatedAnime
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnimeCopyWith<$Res> get anime {
  
  return $AnimeCopyWith<$Res>(_self.anime, (value) {
    return _then(_self.copyWith(anime: value));
  });
}
}

/// @nodoc
mixin _$VoiceActor {

 int get id; String get name;
/// Create a copy of VoiceActor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceActorCopyWith<VoiceActor> get copyWith => _$VoiceActorCopyWithImpl<VoiceActor>(this as VoiceActor, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VoiceActor;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceActor&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}


@override
int get hashCode {
  final _this = this as VoiceActor;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as VoiceActor;
  return 'VoiceActor(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $VoiceActorCopyWith<$Res>  {
  factory $VoiceActorCopyWith(VoiceActor value, $Res Function(VoiceActor) _then) = _$VoiceActorCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$VoiceActorCopyWithImpl<$Res>
    implements $VoiceActorCopyWith<$Res> {
  _$VoiceActorCopyWithImpl(this._self, this._then);

  final VoiceActor _self;
  final $Res Function(VoiceActor) _then;

/// Create a copy of VoiceActor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(VoiceActor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceActor].
extension VoiceActorPatterns on VoiceActor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceActor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceActor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceActor value)  $default,){
final _that = this;
switch (_that) {
case _VoiceActor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceActor value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceActor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceActor() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _VoiceActor():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _VoiceActor() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _VoiceActor implements VoiceActor {
  const _VoiceActor({required this.id, required this.name});
  

@override final  int id;
@override final  String name;

/// Create a copy of VoiceActor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceActorCopyWith<_VoiceActor> get copyWith => __$VoiceActorCopyWithImpl<_VoiceActor>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceActor&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'VoiceActor(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$VoiceActorCopyWith<$Res> implements $VoiceActorCopyWith<$Res> {
  factory _$VoiceActorCopyWith(_VoiceActor value, $Res Function(_VoiceActor) _then) = __$VoiceActorCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$VoiceActorCopyWithImpl<$Res>
    implements _$VoiceActorCopyWith<$Res> {
  __$VoiceActorCopyWithImpl(this._self, this._then);

  final _VoiceActor _self;
  final $Res Function(_VoiceActor) _then;

/// Create a copy of VoiceActor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_VoiceActor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AnimeCharacter {

 int get id; String get name; String get image; String get relation; List<VoiceActor> get actors;
/// Create a copy of AnimeCharacter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnimeCharacterCopyWith<AnimeCharacter> get copyWith => _$AnimeCharacterCopyWithImpl<AnimeCharacter>(this as AnimeCharacter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AnimeCharacter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnimeCharacter&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.image, _this.image) || other.image == _this.image)&&(identical(other.relation, _this.relation) || other.relation == _this.relation)&&const DeepCollectionEquality().equals(other.actors, _this.actors));
}


@override
int get hashCode {
  final _this = this as AnimeCharacter;
  return Object.hash(runtimeType,_this.id,_this.name,_this.image,_this.relation,const DeepCollectionEquality().hash(_this.actors));
}

@override
String toString() {
  final _this = this as AnimeCharacter;
  return 'AnimeCharacter(id: ${_this.id}, name: ${_this.name}, image: ${_this.image}, relation: ${_this.relation}, actors: ${_this.actors})';
}


}

/// @nodoc
abstract mixin class $AnimeCharacterCopyWith<$Res>  {
  factory $AnimeCharacterCopyWith(AnimeCharacter value, $Res Function(AnimeCharacter) _then) = _$AnimeCharacterCopyWithImpl;
@useResult
$Res call({
 int id, String name, String image, String relation, List<VoiceActor> actors
});




}
/// @nodoc
class _$AnimeCharacterCopyWithImpl<$Res>
    implements $AnimeCharacterCopyWith<$Res> {
  _$AnimeCharacterCopyWithImpl(this._self, this._then);

  final AnimeCharacter _self;
  final $Res Function(AnimeCharacter) _then;

/// Create a copy of AnimeCharacter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? image = null,Object? relation = null,Object? actors = null,}) {
  return _then(AnimeCharacter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String,actors: null == actors ? _self.actors : actors // ignore: cast_nullable_to_non_nullable
as List<VoiceActor>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnimeCharacter].
extension AnimeCharacterPatterns on AnimeCharacter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnimeCharacter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnimeCharacter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnimeCharacter value)  $default,){
final _that = this;
switch (_that) {
case _AnimeCharacter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnimeCharacter value)?  $default,){
final _that = this;
switch (_that) {
case _AnimeCharacter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String image,  String relation,  List<VoiceActor> actors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnimeCharacter() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.relation,_that.actors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String image,  String relation,  List<VoiceActor> actors)  $default,) {final _that = this;
switch (_that) {
case _AnimeCharacter():
return $default(_that.id,_that.name,_that.image,_that.relation,_that.actors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String image,  String relation,  List<VoiceActor> actors)?  $default,) {final _that = this;
switch (_that) {
case _AnimeCharacter() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.relation,_that.actors);case _:
  return null;

}
}

}

/// @nodoc


class _AnimeCharacter implements AnimeCharacter {
  const _AnimeCharacter({required this.id, required this.name, this.image = '', this.relation = '',  List<VoiceActor> actors = const []}): _actors = actors;
  

@override final  int id;
@override final  String name;
@override@JsonKey() final  String image;
@override@JsonKey() final  String relation;
 final  List<VoiceActor> _actors;
@override@JsonKey() List<VoiceActor> get actors {
  if (_actors is EqualUnmodifiableListView) return _actors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actors);
}


/// Create a copy of AnimeCharacter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnimeCharacterCopyWith<_AnimeCharacter> get copyWith => __$AnimeCharacterCopyWithImpl<_AnimeCharacter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnimeCharacter&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.relation, relation) || other.relation == relation)&&const DeepCollectionEquality().equals(other.actors, _actors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,image,relation,const DeepCollectionEquality().hash(_actors));
}

@override
String toString() {
    return 'AnimeCharacter(id: $id, name: $name, image: $image, relation: $relation, actors: $actors)';
}


}

/// @nodoc
abstract mixin class _$AnimeCharacterCopyWith<$Res> implements $AnimeCharacterCopyWith<$Res> {
  factory _$AnimeCharacterCopyWith(_AnimeCharacter value, $Res Function(_AnimeCharacter) _then) = __$AnimeCharacterCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String image, String relation, List<VoiceActor> actors
});




}
/// @nodoc
class __$AnimeCharacterCopyWithImpl<$Res>
    implements _$AnimeCharacterCopyWith<$Res> {
  __$AnimeCharacterCopyWithImpl(this._self, this._then);

  final _AnimeCharacter _self;
  final $Res Function(_AnimeCharacter) _then;

/// Create a copy of AnimeCharacter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? image = null,Object? relation = null,Object? actors = null,}) {
  return _then(_AnimeCharacter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,relation: null == relation ? _self.relation : relation // ignore: cast_nullable_to_non_nullable
as String,actors: null == actors ? _self._actors : actors // ignore: cast_nullable_to_non_nullable
as List<VoiceActor>,
  ));
}


}

// dart format on
