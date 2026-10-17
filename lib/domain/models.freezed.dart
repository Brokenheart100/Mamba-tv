// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Anime {

 int get id; String get title; String get originalTitle; String get image; String get summary; String get date; double get score; int get episodeCount; List<String> get tags;
/// Create a copy of Anime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnimeCopyWith<Anime> get copyWith => _$AnimeCopyWithImpl<Anime>(this as Anime, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Anime;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Anime&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.originalTitle, _this.originalTitle) || other.originalTitle == _this.originalTitle)&&(identical(other.image, _this.image) || other.image == _this.image)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.score, _this.score) || other.score == _this.score)&&(identical(other.episodeCount, _this.episodeCount) || other.episodeCount == _this.episodeCount)&&const DeepCollectionEquality().equals(other.tags, _this.tags));
}


@override
int get hashCode {
  final _this = this as Anime;
  return Object.hash(runtimeType,_this.id,_this.title,_this.originalTitle,_this.image,_this.summary,_this.date,_this.score,_this.episodeCount,const DeepCollectionEquality().hash(_this.tags));
}

@override
String toString() {
  final _this = this as Anime;
  return 'Anime(id: ${_this.id}, title: ${_this.title}, originalTitle: ${_this.originalTitle}, image: ${_this.image}, summary: ${_this.summary}, date: ${_this.date}, score: ${_this.score}, episodeCount: ${_this.episodeCount}, tags: ${_this.tags})';
}


}

/// @nodoc
abstract mixin class $AnimeCopyWith<$Res>  {
  factory $AnimeCopyWith(Anime value, $Res Function(Anime) _then) = _$AnimeCopyWithImpl;
@useResult
$Res call({
 int id, String title, String originalTitle, String image, String summary, String date, double score, int episodeCount, List<String> tags
});




}
/// @nodoc
class _$AnimeCopyWithImpl<$Res>
    implements $AnimeCopyWith<$Res> {
  _$AnimeCopyWithImpl(this._self, this._then);

  final Anime _self;
  final $Res Function(Anime) _then;

/// Create a copy of Anime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? originalTitle = null,Object? image = null,Object? summary = null,Object? date = null,Object? score = null,Object? episodeCount = null,Object? tags = null,}) {
  return _then(Anime(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: null == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Anime].
extension AnimePatterns on Anime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Anime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Anime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Anime value)  $default,){
final _that = this;
switch (_that) {
case _Anime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Anime value)?  $default,){
final _that = this;
switch (_that) {
case _Anime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String originalTitle,  String image,  String summary,  String date,  double score,  int episodeCount,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Anime() when $default != null:
return $default(_that.id,_that.title,_that.originalTitle,_that.image,_that.summary,_that.date,_that.score,_that.episodeCount,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String originalTitle,  String image,  String summary,  String date,  double score,  int episodeCount,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _Anime():
return $default(_that.id,_that.title,_that.originalTitle,_that.image,_that.summary,_that.date,_that.score,_that.episodeCount,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String originalTitle,  String image,  String summary,  String date,  double score,  int episodeCount,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _Anime() when $default != null:
return $default(_that.id,_that.title,_that.originalTitle,_that.image,_that.summary,_that.date,_that.score,_that.episodeCount,_that.tags);case _:
  return null;

}
}

}

/// @nodoc


class _Anime implements Anime {
  const _Anime({required this.id, required this.title, this.originalTitle = '', this.image = '', this.summary = '', this.date = '', this.score = 0, this.episodeCount = 0,  List<String> tags = const <String>[]}): _tags = tags;
  

@override final  int id;
@override final  String title;
@override@JsonKey() final  String originalTitle;
@override@JsonKey() final  String image;
@override@JsonKey() final  String summary;
@override@JsonKey() final  String date;
@override@JsonKey() final  double score;
@override@JsonKey() final  int episodeCount;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of Anime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnimeCopyWith<_Anime> get copyWith => __$AnimeCopyWithImpl<_Anime>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Anime&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.image, image) || other.image == image)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.date, date) || other.date == date)&&(identical(other.score, score) || other.score == score)&&(identical(other.episodeCount, episodeCount) || other.episodeCount == episodeCount)&&const DeepCollectionEquality().equals(other.tags, _tags));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,originalTitle,image,summary,date,score,episodeCount,const DeepCollectionEquality().hash(_tags));
}

@override
String toString() {
    return 'Anime(id: $id, title: $title, originalTitle: $originalTitle, image: $image, summary: $summary, date: $date, score: $score, episodeCount: $episodeCount, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$AnimeCopyWith<$Res> implements $AnimeCopyWith<$Res> {
  factory _$AnimeCopyWith(_Anime value, $Res Function(_Anime) _then) = __$AnimeCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String originalTitle, String image, String summary, String date, double score, int episodeCount, List<String> tags
});




}
/// @nodoc
class __$AnimeCopyWithImpl<$Res>
    implements _$AnimeCopyWith<$Res> {
  __$AnimeCopyWithImpl(this._self, this._then);

  final _Anime _self;
  final $Res Function(_Anime) _then;

/// Create a copy of Anime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? originalTitle = null,Object? image = null,Object? summary = null,Object? date = null,Object? score = null,Object? episodeCount = null,Object? tags = null,}) {
  return _then(_Anime(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: null == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,episodeCount: null == episodeCount ? _self.episodeCount : episodeCount // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$Episode {

 int get id; int get subjectId; String get title; double get sort; int get type;
/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeCopyWith<Episode> get copyWith => _$EpisodeCopyWithImpl<Episode>(this as Episode, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Episode;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Episode&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.subjectId, _this.subjectId) || other.subjectId == _this.subjectId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.type, _this.type) || other.type == _this.type));
}


@override
int get hashCode {
  final _this = this as Episode;
  return Object.hash(runtimeType,_this.id,_this.subjectId,_this.title,_this.sort,_this.type);
}

@override
String toString() {
  final _this = this as Episode;
  return 'Episode(id: ${_this.id}, subjectId: ${_this.subjectId}, title: ${_this.title}, sort: ${_this.sort}, type: ${_this.type})';
}


}

/// @nodoc
abstract mixin class $EpisodeCopyWith<$Res>  {
  factory $EpisodeCopyWith(Episode value, $Res Function(Episode) _then) = _$EpisodeCopyWithImpl;
@useResult
$Res call({
 int id, int subjectId, String title, double sort, int type
});




}
/// @nodoc
class _$EpisodeCopyWithImpl<$Res>
    implements $EpisodeCopyWith<$Res> {
  _$EpisodeCopyWithImpl(this._self, this._then);

  final Episode _self;
  final $Res Function(Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? subjectId = null,Object? title = null,Object? sort = null,Object? type = null,}) {
  return _then(Episode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Episode].
extension EpisodePatterns on Episode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Episode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Episode value)  $default,){
final _that = this;
switch (_that) {
case _Episode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Episode value)?  $default,){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int subjectId,  String title,  double sort,  int type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.id,_that.subjectId,_that.title,_that.sort,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int subjectId,  String title,  double sort,  int type)  $default,) {final _that = this;
switch (_that) {
case _Episode():
return $default(_that.id,_that.subjectId,_that.title,_that.sort,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int subjectId,  String title,  double sort,  int type)?  $default,) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.id,_that.subjectId,_that.title,_that.sort,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _Episode implements Episode {
  const _Episode({required this.id, required this.subjectId, required this.title, required this.sort, this.type = 0});
  

@override final  int id;
@override final  int subjectId;
@override final  String title;
@override final  double sort;
@override@JsonKey() final  int type;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeCopyWith<_Episode> get copyWith => __$EpisodeCopyWithImpl<_Episode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Episode&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,subjectId,title,sort,type);
}

@override
String toString() {
    return 'Episode(id: $id, subjectId: $subjectId, title: $title, sort: $sort, type: $type)';
}


}

/// @nodoc
abstract mixin class _$EpisodeCopyWith<$Res> implements $EpisodeCopyWith<$Res> {
  factory _$EpisodeCopyWith(_Episode value, $Res Function(_Episode) _then) = __$EpisodeCopyWithImpl;
@override @useResult
$Res call({
 int id, int subjectId, String title, double sort, int type
});




}
/// @nodoc
class __$EpisodeCopyWithImpl<$Res>
    implements _$EpisodeCopyWith<$Res> {
  __$EpisodeCopyWithImpl(this._self, this._then);

  final _Episode _self;
  final $Res Function(_Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? subjectId = null,Object? title = null,Object? sort = null,Object? type = null,}) {
  return _then(_Episode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$WatchProgress {

 Anime get anime; Episode get episode; Duration get position; Duration get duration; DateTime get updatedAt;
/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchProgressCopyWith<WatchProgress> get copyWith => _$WatchProgressCopyWithImpl<WatchProgress>(this as WatchProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WatchProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchProgress&&(identical(other.anime, _this.anime) || other.anime == _this.anime)&&(identical(other.episode, _this.episode) || other.episode == _this.episode)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as WatchProgress;
  return Object.hash(runtimeType,_this.anime,_this.episode,_this.position,_this.duration,_this.updatedAt);
}

@override
String toString() {
  final _this = this as WatchProgress;
  return 'WatchProgress(anime: ${_this.anime}, episode: ${_this.episode}, position: ${_this.position}, duration: ${_this.duration}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $WatchProgressCopyWith<$Res>  {
  factory $WatchProgressCopyWith(WatchProgress value, $Res Function(WatchProgress) _then) = _$WatchProgressCopyWithImpl;
@useResult
$Res call({
 Anime anime, Episode episode, Duration position, Duration duration, DateTime updatedAt
});


$AnimeCopyWith<$Res> get anime;$EpisodeCopyWith<$Res> get episode;

}
/// @nodoc
class _$WatchProgressCopyWithImpl<$Res>
    implements $WatchProgressCopyWith<$Res> {
  _$WatchProgressCopyWithImpl(this._self, this._then);

  final WatchProgress _self;
  final $Res Function(WatchProgress) _then;

/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anime = null,Object? episode = null,Object? position = null,Object? duration = null,Object? updatedAt = null,}) {
  return _then(WatchProgress(
anime: null == anime ? _self.anime : anime // ignore: cast_nullable_to_non_nullable
as Anime,episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnimeCopyWith<$Res> get anime {
  
  return $AnimeCopyWith<$Res>(_self.anime, (value) {
    return _then(_self.copyWith(anime: value));
  });
}/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res> get episode {
  
  return $EpisodeCopyWith<$Res>(_self.episode, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}


/// Adds pattern-matching-related methods to [WatchProgress].
extension WatchProgressPatterns on WatchProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchProgress value)  $default,){
final _that = this;
switch (_that) {
case _WatchProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchProgress value)?  $default,){
final _that = this;
switch (_that) {
case _WatchProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Anime anime,  Episode episode,  Duration position,  Duration duration,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchProgress() when $default != null:
return $default(_that.anime,_that.episode,_that.position,_that.duration,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Anime anime,  Episode episode,  Duration position,  Duration duration,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WatchProgress():
return $default(_that.anime,_that.episode,_that.position,_that.duration,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Anime anime,  Episode episode,  Duration position,  Duration duration,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WatchProgress() when $default != null:
return $default(_that.anime,_that.episode,_that.position,_that.duration,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _WatchProgress implements WatchProgress {
  const _WatchProgress({required this.anime, required this.episode, required this.position, required this.duration, required this.updatedAt});
  

@override final  Anime anime;
@override final  Episode episode;
@override final  Duration position;
@override final  Duration duration;
@override final  DateTime updatedAt;

/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchProgressCopyWith<_WatchProgress> get copyWith => __$WatchProgressCopyWithImpl<_WatchProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchProgress&&(identical(other.anime, anime) || other.anime == anime)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,anime,episode,position,duration,updatedAt);
}

@override
String toString() {
    return 'WatchProgress(anime: $anime, episode: $episode, position: $position, duration: $duration, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WatchProgressCopyWith<$Res> implements $WatchProgressCopyWith<$Res> {
  factory _$WatchProgressCopyWith(_WatchProgress value, $Res Function(_WatchProgress) _then) = __$WatchProgressCopyWithImpl;
@override @useResult
$Res call({
 Anime anime, Episode episode, Duration position, Duration duration, DateTime updatedAt
});


@override $AnimeCopyWith<$Res> get anime;@override $EpisodeCopyWith<$Res> get episode;

}
/// @nodoc
class __$WatchProgressCopyWithImpl<$Res>
    implements _$WatchProgressCopyWith<$Res> {
  __$WatchProgressCopyWithImpl(this._self, this._then);

  final _WatchProgress _self;
  final $Res Function(_WatchProgress) _then;

/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anime = null,Object? episode = null,Object? position = null,Object? duration = null,Object? updatedAt = null,}) {
  return _then(_WatchProgress(
anime: null == anime ? _self.anime : anime // ignore: cast_nullable_to_non_nullable
as Anime,episode: null == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnimeCopyWith<$Res> get anime {
  
  return $AnimeCopyWith<$Res>(_self.anime, (value) {
    return _then(_self.copyWith(anime: value));
  });
}/// Create a copy of WatchProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res> get episode {
  
  return $EpisodeCopyWith<$Res>(_self.episode, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}


/// @nodoc
mixin _$MediaSourceBinding {

 String get sourceId; String get label; String get address; bool get needsResolution; Map<String, String> get context;
/// Create a copy of MediaSourceBinding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaSourceBindingCopyWith<MediaSourceBinding> get copyWith => _$MediaSourceBindingCopyWithImpl<MediaSourceBinding>(this as MediaSourceBinding, _$identity);

  /// Serializes this MediaSourceBinding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MediaSourceBinding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaSourceBinding&&(identical(other.sourceId, _this.sourceId) || other.sourceId == _this.sourceId)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.needsResolution, _this.needsResolution) || other.needsResolution == _this.needsResolution)&&const DeepCollectionEquality().equals(other.context, _this.context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MediaSourceBinding;
  return Object.hash(runtimeType,_this.sourceId,_this.label,_this.address,_this.needsResolution,const DeepCollectionEquality().hash(_this.context));
}

@override
String toString() {
  final _this = this as MediaSourceBinding;
  return 'MediaSourceBinding(sourceId: ${_this.sourceId}, label: ${_this.label}, address: ${_this.address}, needsResolution: ${_this.needsResolution}, context: ${_this.context})';
}


}

/// @nodoc
abstract mixin class $MediaSourceBindingCopyWith<$Res>  {
  factory $MediaSourceBindingCopyWith(MediaSourceBinding value, $Res Function(MediaSourceBinding) _then) = _$MediaSourceBindingCopyWithImpl;
@useResult
$Res call({
 String sourceId, String label, String address, bool needsResolution, Map<String, String> context
});




}
/// @nodoc
class _$MediaSourceBindingCopyWithImpl<$Res>
    implements $MediaSourceBindingCopyWith<$Res> {
  _$MediaSourceBindingCopyWithImpl(this._self, this._then);

  final MediaSourceBinding _self;
  final $Res Function(MediaSourceBinding) _then;

/// Create a copy of MediaSourceBinding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceId = null,Object? label = null,Object? address = null,Object? needsResolution = null,Object? context = null,}) {
  return _then(MediaSourceBinding(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,needsResolution: null == needsResolution ? _self.needsResolution : needsResolution // ignore: cast_nullable_to_non_nullable
as bool,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaSourceBinding].
extension MediaSourceBindingPatterns on MediaSourceBinding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaSourceBinding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaSourceBinding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaSourceBinding value)  $default,){
final _that = this;
switch (_that) {
case _MediaSourceBinding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaSourceBinding value)?  $default,){
final _that = this;
switch (_that) {
case _MediaSourceBinding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceId,  String label,  String address,  bool needsResolution,  Map<String, String> context)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaSourceBinding() when $default != null:
return $default(_that.sourceId,_that.label,_that.address,_that.needsResolution,_that.context);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceId,  String label,  String address,  bool needsResolution,  Map<String, String> context)  $default,) {final _that = this;
switch (_that) {
case _MediaSourceBinding():
return $default(_that.sourceId,_that.label,_that.address,_that.needsResolution,_that.context);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceId,  String label,  String address,  bool needsResolution,  Map<String, String> context)?  $default,) {final _that = this;
switch (_that) {
case _MediaSourceBinding() when $default != null:
return $default(_that.sourceId,_that.label,_that.address,_that.needsResolution,_that.context);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaSourceBinding implements MediaSourceBinding {
  const _MediaSourceBinding({required this.sourceId, required this.label, required this.address, this.needsResolution = true,  Map<String, String> context = const <String, String>{}}): _context = context;
  factory _MediaSourceBinding.fromJson(Map<String, dynamic> json) => _$MediaSourceBindingFromJson(json);

@override final  String sourceId;
@override final  String label;
@override final  String address;
@override@JsonKey() final  bool needsResolution;
 final  Map<String, String> _context;
@override@JsonKey() Map<String, String> get context {
  if (_context is EqualUnmodifiableMapView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_context);
}


/// Create a copy of MediaSourceBinding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaSourceBindingCopyWith<_MediaSourceBinding> get copyWith => __$MediaSourceBindingCopyWithImpl<_MediaSourceBinding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaSourceBindingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaSourceBinding&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.label, label) || other.label == label)&&(identical(other.address, address) || other.address == address)&&(identical(other.needsResolution, needsResolution) || other.needsResolution == needsResolution)&&const DeepCollectionEquality().equals(other.context, _context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sourceId,label,address,needsResolution,const DeepCollectionEquality().hash(_context));
}

@override
String toString() {
    return 'MediaSourceBinding(sourceId: $sourceId, label: $label, address: $address, needsResolution: $needsResolution, context: $context)';
}


}

/// @nodoc
abstract mixin class _$MediaSourceBindingCopyWith<$Res> implements $MediaSourceBindingCopyWith<$Res> {
  factory _$MediaSourceBindingCopyWith(_MediaSourceBinding value, $Res Function(_MediaSourceBinding) _then) = __$MediaSourceBindingCopyWithImpl;
@override @useResult
$Res call({
 String sourceId, String label, String address, bool needsResolution, Map<String, String> context
});




}
/// @nodoc
class __$MediaSourceBindingCopyWithImpl<$Res>
    implements _$MediaSourceBindingCopyWith<$Res> {
  __$MediaSourceBindingCopyWithImpl(this._self, this._then);

  final _MediaSourceBinding _self;
  final $Res Function(_MediaSourceBinding) _then;

/// Create a copy of MediaSourceBinding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceId = null,Object? label = null,Object? address = null,Object? needsResolution = null,Object? context = null,}) {
  return _then(_MediaSourceBinding(
sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,needsResolution: null == needsResolution ? _self.needsResolution : needsResolution // ignore: cast_nullable_to_non_nullable
as bool,context: null == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
