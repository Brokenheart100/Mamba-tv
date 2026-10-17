import 'package:freezed_annotation/freezed_annotation.dart';

part 'anime_filter.freezed.dart';

enum AnimeRegion { all, japan, china, western }

enum AnimeFormat { all, tv, movie, ova, web }

enum AnimeSort { rank, heat, score }

/// A catalogue query. The data layer translates these values to API filters.
@freezed
abstract class AnimeFilter with _$AnimeFilter {
  const factory AnimeFilter({
    @Default(AnimeRegion.all) AnimeRegion region,
    @Default(AnimeFormat.all) AnimeFormat format,
    String? genre,

    /// Zero includes every year; -1 includes releases before 2000.
    @Default(0) int year,
    @Default(AnimeSort.rank) AnimeSort sort,
  }) = _AnimeFilter;
}
