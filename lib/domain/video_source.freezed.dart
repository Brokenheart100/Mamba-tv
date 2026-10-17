// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoSource {

 String get id; String get name; String get endpoint; bool get enabled; String get factoryId; Map<String, dynamic> get arguments; String? get subscriptionUrl; int get tier;
/// Create a copy of VideoSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoSourceCopyWith<VideoSource> get copyWith => _$VideoSourceCopyWithImpl<VideoSource>(this as VideoSource, _$identity);

  /// Serializes this VideoSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VideoSource;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoSource&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.endpoint, _this.endpoint) || other.endpoint == _this.endpoint)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.factoryId, _this.factoryId) || other.factoryId == _this.factoryId)&&const DeepCollectionEquality().equals(other.arguments, _this.arguments)&&(identical(other.subscriptionUrl, _this.subscriptionUrl) || other.subscriptionUrl == _this.subscriptionUrl)&&(identical(other.tier, _this.tier) || other.tier == _this.tier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VideoSource;
  return Object.hash(runtimeType,_this.id,_this.name,_this.endpoint,_this.enabled,_this.factoryId,const DeepCollectionEquality().hash(_this.arguments),_this.subscriptionUrl,_this.tier);
}

@override
String toString() {
  final _this = this as VideoSource;
  return 'VideoSource(id: ${_this.id}, name: ${_this.name}, endpoint: ${_this.endpoint}, enabled: ${_this.enabled}, factoryId: ${_this.factoryId}, arguments: ${_this.arguments}, subscriptionUrl: ${_this.subscriptionUrl}, tier: ${_this.tier})';
}


}

/// @nodoc
abstract mixin class $VideoSourceCopyWith<$Res>  {
  factory $VideoSourceCopyWith(VideoSource value, $Res Function(VideoSource) _then) = _$VideoSourceCopyWithImpl;
@useResult
$Res call({
 String id, String name, String endpoint, bool enabled, String factoryId, Map<String, dynamic> arguments, String? subscriptionUrl, int tier
});




}
/// @nodoc
class _$VideoSourceCopyWithImpl<$Res>
    implements $VideoSourceCopyWith<$Res> {
  _$VideoSourceCopyWithImpl(this._self, this._then);

  final VideoSource _self;
  final $Res Function(VideoSource) _then;

/// Create a copy of VideoSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? endpoint = null,Object? enabled = null,Object? factoryId = null,Object? arguments = null,Object? subscriptionUrl = freezed,Object? tier = null,}) {
  return _then(VideoSource(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,factoryId: null == factoryId ? _self.factoryId : factoryId // ignore: cast_nullable_to_non_nullable
as String,arguments: null == arguments ? _self.arguments : arguments // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,subscriptionUrl: freezed == subscriptionUrl ? _self.subscriptionUrl : subscriptionUrl // ignore: cast_nullable_to_non_nullable
as String?,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoSource].
extension VideoSourcePatterns on VideoSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoSource value)  $default,){
final _that = this;
switch (_that) {
case _VideoSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoSource value)?  $default,){
final _that = this;
switch (_that) {
case _VideoSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String endpoint,  bool enabled,  String factoryId,  Map<String, dynamic> arguments,  String? subscriptionUrl,  int tier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoSource() when $default != null:
return $default(_that.id,_that.name,_that.endpoint,_that.enabled,_that.factoryId,_that.arguments,_that.subscriptionUrl,_that.tier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String endpoint,  bool enabled,  String factoryId,  Map<String, dynamic> arguments,  String? subscriptionUrl,  int tier)  $default,) {final _that = this;
switch (_that) {
case _VideoSource():
return $default(_that.id,_that.name,_that.endpoint,_that.enabled,_that.factoryId,_that.arguments,_that.subscriptionUrl,_that.tier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String endpoint,  bool enabled,  String factoryId,  Map<String, dynamic> arguments,  String? subscriptionUrl,  int tier)?  $default,) {final _that = this;
switch (_that) {
case _VideoSource() when $default != null:
return $default(_that.id,_that.name,_that.endpoint,_that.enabled,_that.factoryId,_that.arguments,_that.subscriptionUrl,_that.tier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoSource implements VideoSource {
  const _VideoSource({required this.id, required this.name, required this.endpoint, this.enabled = true, this.factoryId = 'maccms',  Map<String, dynamic> arguments = const <String, dynamic>{}, this.subscriptionUrl, this.tier = 2}): _arguments = arguments;
  factory _VideoSource.fromJson(Map<String, dynamic> json) => _$VideoSourceFromJson(json);

@override final  String id;
@override final  String name;
@override final  String endpoint;
@override@JsonKey() final  bool enabled;
@override@JsonKey() final  String factoryId;
 final  Map<String, dynamic> _arguments;
@override@JsonKey() Map<String, dynamic> get arguments {
  if (_arguments is EqualUnmodifiableMapView) return _arguments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_arguments);
}

@override final  String? subscriptionUrl;
@override@JsonKey() final  int tier;

/// Create a copy of VideoSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoSourceCopyWith<_VideoSource> get copyWith => __$VideoSourceCopyWithImpl<_VideoSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoSourceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoSource&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.factoryId, factoryId) || other.factoryId == factoryId)&&const DeepCollectionEquality().equals(other.arguments, _arguments)&&(identical(other.subscriptionUrl, subscriptionUrl) || other.subscriptionUrl == subscriptionUrl)&&(identical(other.tier, tier) || other.tier == tier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,endpoint,enabled,factoryId,const DeepCollectionEquality().hash(_arguments),subscriptionUrl,tier);
}

@override
String toString() {
    return 'VideoSource(id: $id, name: $name, endpoint: $endpoint, enabled: $enabled, factoryId: $factoryId, arguments: $arguments, subscriptionUrl: $subscriptionUrl, tier: $tier)';
}


}

/// @nodoc
abstract mixin class _$VideoSourceCopyWith<$Res> implements $VideoSourceCopyWith<$Res> {
  factory _$VideoSourceCopyWith(_VideoSource value, $Res Function(_VideoSource) _then) = __$VideoSourceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String endpoint, bool enabled, String factoryId, Map<String, dynamic> arguments, String? subscriptionUrl, int tier
});




}
/// @nodoc
class __$VideoSourceCopyWithImpl<$Res>
    implements _$VideoSourceCopyWith<$Res> {
  __$VideoSourceCopyWithImpl(this._self, this._then);

  final _VideoSource _self;
  final $Res Function(_VideoSource) _then;

/// Create a copy of VideoSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? endpoint = null,Object? enabled = null,Object? factoryId = null,Object? arguments = null,Object? subscriptionUrl = freezed,Object? tier = null,}) {
  return _then(_VideoSource(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,factoryId: null == factoryId ? _self.factoryId : factoryId // ignore: cast_nullable_to_non_nullable
as String,arguments: null == arguments ? _self._arguments : arguments // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,subscriptionUrl: freezed == subscriptionUrl ? _self.subscriptionUrl : subscriptionUrl // ignore: cast_nullable_to_non_nullable
as String?,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SourceTitle {

 String get id; String get title; String get year; String get remarks; String get category;
/// Create a copy of SourceTitle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SourceTitleCopyWith<SourceTitle> get copyWith => _$SourceTitleCopyWithImpl<SourceTitle>(this as SourceTitle, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SourceTitle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SourceTitle&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.remarks, _this.remarks) || other.remarks == _this.remarks)&&(identical(other.category, _this.category) || other.category == _this.category));
}


@override
int get hashCode {
  final _this = this as SourceTitle;
  return Object.hash(runtimeType,_this.id,_this.title,_this.year,_this.remarks,_this.category);
}

@override
String toString() {
  final _this = this as SourceTitle;
  return 'SourceTitle(id: ${_this.id}, title: ${_this.title}, year: ${_this.year}, remarks: ${_this.remarks}, category: ${_this.category})';
}


}

/// @nodoc
abstract mixin class $SourceTitleCopyWith<$Res>  {
  factory $SourceTitleCopyWith(SourceTitle value, $Res Function(SourceTitle) _then) = _$SourceTitleCopyWithImpl;
@useResult
$Res call({
 String id, String title, String year, String remarks, String category
});




}
/// @nodoc
class _$SourceTitleCopyWithImpl<$Res>
    implements $SourceTitleCopyWith<$Res> {
  _$SourceTitleCopyWithImpl(this._self, this._then);

  final SourceTitle _self;
  final $Res Function(SourceTitle) _then;

/// Create a copy of SourceTitle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? year = null,Object? remarks = null,Object? category = null,}) {
  return _then(SourceTitle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,remarks: null == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SourceTitle].
extension SourceTitlePatterns on SourceTitle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SourceTitle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SourceTitle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SourceTitle value)  $default,){
final _that = this;
switch (_that) {
case _SourceTitle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SourceTitle value)?  $default,){
final _that = this;
switch (_that) {
case _SourceTitle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String year,  String remarks,  String category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SourceTitle() when $default != null:
return $default(_that.id,_that.title,_that.year,_that.remarks,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String year,  String remarks,  String category)  $default,) {final _that = this;
switch (_that) {
case _SourceTitle():
return $default(_that.id,_that.title,_that.year,_that.remarks,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String year,  String remarks,  String category)?  $default,) {final _that = this;
switch (_that) {
case _SourceTitle() when $default != null:
return $default(_that.id,_that.title,_that.year,_that.remarks,_that.category);case _:
  return null;

}
}

}

/// @nodoc


class _SourceTitle implements SourceTitle {
  const _SourceTitle({required this.id, required this.title, this.year = '', this.remarks = '', this.category = ''});
  

@override final  String id;
@override final  String title;
@override@JsonKey() final  String year;
@override@JsonKey() final  String remarks;
@override@JsonKey() final  String category;

/// Create a copy of SourceTitle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SourceTitleCopyWith<_SourceTitle> get copyWith => __$SourceTitleCopyWithImpl<_SourceTitle>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SourceTitle&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.year, year) || other.year == year)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,year,remarks,category);
}

@override
String toString() {
    return 'SourceTitle(id: $id, title: $title, year: $year, remarks: $remarks, category: $category)';
}


}

/// @nodoc
abstract mixin class _$SourceTitleCopyWith<$Res> implements $SourceTitleCopyWith<$Res> {
  factory _$SourceTitleCopyWith(_SourceTitle value, $Res Function(_SourceTitle) _then) = __$SourceTitleCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String year, String remarks, String category
});




}
/// @nodoc
class __$SourceTitleCopyWithImpl<$Res>
    implements _$SourceTitleCopyWith<$Res> {
  __$SourceTitleCopyWithImpl(this._self, this._then);

  final _SourceTitle _self;
  final $Res Function(_SourceTitle) _then;

/// Create a copy of SourceTitle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? year = null,Object? remarks = null,Object? category = null,}) {
  return _then(_SourceTitle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as String,remarks: null == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
