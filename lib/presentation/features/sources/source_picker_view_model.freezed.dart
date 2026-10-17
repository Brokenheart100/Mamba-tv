// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'source_picker_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SourcePickerState {

 Anime? get anime; Episode? get episode; List<VideoSource> get sources; VideoSource? get source; String get query; List<SourceTitle> get results; SourceTitle? get title; List<SourceLine> get lines; bool get loading; bool get loadingMore; bool get saving; int get page; int get pageCount; int get total; String? get error;
/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SourcePickerStateCopyWith<SourcePickerState> get copyWith => _$SourcePickerStateCopyWithImpl<SourcePickerState>(this as SourcePickerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SourcePickerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SourcePickerState&&(identical(other.anime, _this.anime) || other.anime == _this.anime)&&(identical(other.episode, _this.episode) || other.episode == _this.episode)&&const DeepCollectionEquality().equals(other.sources, _this.sources)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.query, _this.query) || other.query == _this.query)&&const DeepCollectionEquality().equals(other.results, _this.results)&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.loadingMore, _this.loadingMore) || other.loadingMore == _this.loadingMore)&&(identical(other.saving, _this.saving) || other.saving == _this.saving)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.pageCount, _this.pageCount) || other.pageCount == _this.pageCount)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as SourcePickerState;
  return Object.hash(runtimeType,_this.anime,_this.episode,const DeepCollectionEquality().hash(_this.sources),_this.source,_this.query,const DeepCollectionEquality().hash(_this.results),_this.title,const DeepCollectionEquality().hash(_this.lines),_this.loading,_this.loadingMore,_this.saving,_this.page,_this.pageCount,_this.total,_this.error);
}

@override
String toString() {
  final _this = this as SourcePickerState;
  return 'SourcePickerState(anime: ${_this.anime}, episode: ${_this.episode}, sources: ${_this.sources}, source: ${_this.source}, query: ${_this.query}, results: ${_this.results}, title: ${_this.title}, lines: ${_this.lines}, loading: ${_this.loading}, loadingMore: ${_this.loadingMore}, saving: ${_this.saving}, page: ${_this.page}, pageCount: ${_this.pageCount}, total: ${_this.total}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $SourcePickerStateCopyWith<$Res>  {
  factory $SourcePickerStateCopyWith(SourcePickerState value, $Res Function(SourcePickerState) _then) = _$SourcePickerStateCopyWithImpl;
@useResult
$Res call({
 Anime? anime, Episode? episode, List<VideoSource> sources, VideoSource? source, String query, List<SourceTitle> results, SourceTitle? title, List<SourceLine> lines, bool loading, bool loadingMore, bool saving, int page, int pageCount, int total, String? error
});


$AnimeCopyWith<$Res>? get anime;$EpisodeCopyWith<$Res>? get episode;$VideoSourceCopyWith<$Res>? get source;$SourceTitleCopyWith<$Res>? get title;

}
/// @nodoc
class _$SourcePickerStateCopyWithImpl<$Res>
    implements $SourcePickerStateCopyWith<$Res> {
  _$SourcePickerStateCopyWithImpl(this._self, this._then);

  final SourcePickerState _self;
  final $Res Function(SourcePickerState) _then;

/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? anime = freezed,Object? episode = freezed,Object? sources = null,Object? source = freezed,Object? query = null,Object? results = null,Object? title = freezed,Object? lines = null,Object? loading = null,Object? loadingMore = null,Object? saving = null,Object? page = null,Object? pageCount = null,Object? total = null,Object? error = freezed,}) {
  return _then(SourcePickerState(
anime: freezed == anime ? _self.anime : anime // ignore: cast_nullable_to_non_nullable
as Anime?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<VideoSource>,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as VideoSource?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SourceTitle>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as SourceTitle?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<SourceLine>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnimeCopyWith<$Res>? get anime {
    if (_self.anime == null) {
    return null;
  }

  return $AnimeCopyWith<$Res>(_self.anime!, (value) {
    return _then(_self.copyWith(anime: value));
  });
}/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res>? get episode {
    if (_self.episode == null) {
    return null;
  }

  return $EpisodeCopyWith<$Res>(_self.episode!, (value) {
    return _then(_self.copyWith(episode: value));
  });
}/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoSourceCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $VideoSourceCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceTitleCopyWith<$Res>? get title {
    if (_self.title == null) {
    return null;
  }

  return $SourceTitleCopyWith<$Res>(_self.title!, (value) {
    return _then(_self.copyWith(title: value));
  });
}
}


/// Adds pattern-matching-related methods to [SourcePickerState].
extension SourcePickerStatePatterns on SourcePickerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SourcePickerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SourcePickerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SourcePickerState value)  $default,){
final _that = this;
switch (_that) {
case _SourcePickerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SourcePickerState value)?  $default,){
final _that = this;
switch (_that) {
case _SourcePickerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Anime? anime,  Episode? episode,  List<VideoSource> sources,  VideoSource? source,  String query,  List<SourceTitle> results,  SourceTitle? title,  List<SourceLine> lines,  bool loading,  bool loadingMore,  bool saving,  int page,  int pageCount,  int total,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SourcePickerState() when $default != null:
return $default(_that.anime,_that.episode,_that.sources,_that.source,_that.query,_that.results,_that.title,_that.lines,_that.loading,_that.loadingMore,_that.saving,_that.page,_that.pageCount,_that.total,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Anime? anime,  Episode? episode,  List<VideoSource> sources,  VideoSource? source,  String query,  List<SourceTitle> results,  SourceTitle? title,  List<SourceLine> lines,  bool loading,  bool loadingMore,  bool saving,  int page,  int pageCount,  int total,  String? error)  $default,) {final _that = this;
switch (_that) {
case _SourcePickerState():
return $default(_that.anime,_that.episode,_that.sources,_that.source,_that.query,_that.results,_that.title,_that.lines,_that.loading,_that.loadingMore,_that.saving,_that.page,_that.pageCount,_that.total,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Anime? anime,  Episode? episode,  List<VideoSource> sources,  VideoSource? source,  String query,  List<SourceTitle> results,  SourceTitle? title,  List<SourceLine> lines,  bool loading,  bool loadingMore,  bool saving,  int page,  int pageCount,  int total,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _SourcePickerState() when $default != null:
return $default(_that.anime,_that.episode,_that.sources,_that.source,_that.query,_that.results,_that.title,_that.lines,_that.loading,_that.loadingMore,_that.saving,_that.page,_that.pageCount,_that.total,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _SourcePickerState implements SourcePickerState {
  const _SourcePickerState({this.anime, this.episode,  List<VideoSource> sources = const <VideoSource>[], this.source, this.query = '',  List<SourceTitle> results = const <SourceTitle>[], this.title,  List<SourceLine> lines = const <SourceLine>[], this.loading = true, this.loadingMore = false, this.saving = false, this.page = 0, this.pageCount = 0, this.total = 0, this.error}): _sources = sources,_results = results,_lines = lines;
  

@override final  Anime? anime;
@override final  Episode? episode;
 final  List<VideoSource> _sources;
@override@JsonKey() List<VideoSource> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override final  VideoSource? source;
@override@JsonKey() final  String query;
 final  List<SourceTitle> _results;
@override@JsonKey() List<SourceTitle> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override final  SourceTitle? title;
 final  List<SourceLine> _lines;
@override@JsonKey() List<SourceLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool loadingMore;
@override@JsonKey() final  bool saving;
@override@JsonKey() final  int page;
@override@JsonKey() final  int pageCount;
@override@JsonKey() final  int total;
@override final  String? error;

/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SourcePickerStateCopyWith<_SourcePickerState> get copyWith => __$SourcePickerStateCopyWithImpl<_SourcePickerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SourcePickerState&&(identical(other.anime, anime) || other.anime == anime)&&(identical(other.episode, episode) || other.episode == episode)&&const DeepCollectionEquality().equals(other.sources, _sources)&&(identical(other.source, source) || other.source == source)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.results, _results)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.total, total) || other.total == total)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,anime,episode,const DeepCollectionEquality().hash(_sources),source,query,const DeepCollectionEquality().hash(_results),title,const DeepCollectionEquality().hash(_lines),loading,loadingMore,saving,page,pageCount,total,error);
}

@override
String toString() {
    return 'SourcePickerState(anime: $anime, episode: $episode, sources: $sources, source: $source, query: $query, results: $results, title: $title, lines: $lines, loading: $loading, loadingMore: $loadingMore, saving: $saving, page: $page, pageCount: $pageCount, total: $total, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SourcePickerStateCopyWith<$Res> implements $SourcePickerStateCopyWith<$Res> {
  factory _$SourcePickerStateCopyWith(_SourcePickerState value, $Res Function(_SourcePickerState) _then) = __$SourcePickerStateCopyWithImpl;
@override @useResult
$Res call({
 Anime? anime, Episode? episode, List<VideoSource> sources, VideoSource? source, String query, List<SourceTitle> results, SourceTitle? title, List<SourceLine> lines, bool loading, bool loadingMore, bool saving, int page, int pageCount, int total, String? error
});


@override $AnimeCopyWith<$Res>? get anime;@override $EpisodeCopyWith<$Res>? get episode;@override $VideoSourceCopyWith<$Res>? get source;@override $SourceTitleCopyWith<$Res>? get title;

}
/// @nodoc
class __$SourcePickerStateCopyWithImpl<$Res>
    implements _$SourcePickerStateCopyWith<$Res> {
  __$SourcePickerStateCopyWithImpl(this._self, this._then);

  final _SourcePickerState _self;
  final $Res Function(_SourcePickerState) _then;

/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? anime = freezed,Object? episode = freezed,Object? sources = null,Object? source = freezed,Object? query = null,Object? results = null,Object? title = freezed,Object? lines = null,Object? loading = null,Object? loadingMore = null,Object? saving = null,Object? page = null,Object? pageCount = null,Object? total = null,Object? error = freezed,}) {
  return _then(_SourcePickerState(
anime: freezed == anime ? _self.anime : anime // ignore: cast_nullable_to_non_nullable
as Anime?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<VideoSource>,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as VideoSource?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SourceTitle>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as SourceTitle?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<SourceLine>,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnimeCopyWith<$Res>? get anime {
    if (_self.anime == null) {
    return null;
  }

  return $AnimeCopyWith<$Res>(_self.anime!, (value) {
    return _then(_self.copyWith(anime: value));
  });
}/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res>? get episode {
    if (_self.episode == null) {
    return null;
  }

  return $EpisodeCopyWith<$Res>(_self.episode!, (value) {
    return _then(_self.copyWith(episode: value));
  });
}/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoSourceCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $VideoSourceCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of SourcePickerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SourceTitleCopyWith<$Res>? get title {
    if (_self.title == null) {
    return null;
  }

  return $SourceTitleCopyWith<$Res>(_self.title!, (value) {
    return _then(_self.copyWith(title: value));
  });
}
}

// dart format on
