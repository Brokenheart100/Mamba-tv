// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _animeJsonMeta = const VerificationMeta(
    'animeJson',
  );
  @override
  late final GeneratedColumn<String> animeJson = GeneratedColumn<String>(
    'anime_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [subjectId, animeJson, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Favorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    }
    if (data.containsKey('anime_json')) {
      context.handle(
        _animeJsonMeta,
        animeJson.isAcceptableOrUnknown(data['anime_json']!, _animeJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_animeJsonMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {subjectId};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      )!,
      animeJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anime_json'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final int subjectId;
  final String animeJson;
  final DateTime addedAt;
  const Favorite({
    required this.subjectId,
    required this.animeJson,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['subject_id'] = Variable<int>(subjectId);
    map['anime_json'] = Variable<String>(animeJson);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      subjectId: Value(subjectId),
      animeJson: Value(animeJson),
      addedAt: Value(addedAt),
    );
  }

  factory Favorite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      subjectId: serializer.fromJson<int>(json['subjectId']),
      animeJson: serializer.fromJson<String>(json['animeJson']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'subjectId': serializer.toJson<int>(subjectId),
      'animeJson': serializer.toJson<String>(animeJson),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  Favorite copyWith({int? subjectId, String? animeJson, DateTime? addedAt}) =>
      Favorite(
        subjectId: subjectId ?? this.subjectId,
        animeJson: animeJson ?? this.animeJson,
        addedAt: addedAt ?? this.addedAt,
      );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      animeJson: data.animeJson.present ? data.animeJson.value : this.animeJson,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('subjectId: $subjectId, ')
          ..write('animeJson: $animeJson, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(subjectId, animeJson, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.subjectId == this.subjectId &&
          other.animeJson == this.animeJson &&
          other.addedAt == this.addedAt);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> subjectId;
  final Value<String> animeJson;
  final Value<DateTime> addedAt;
  const FavoritesCompanion({
    this.subjectId = const Value.absent(),
    this.animeJson = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.subjectId = const Value.absent(),
    required String animeJson,
    required DateTime addedAt,
  }) : animeJson = Value(animeJson),
       addedAt = Value(addedAt);
  static Insertable<Favorite> custom({
    Expression<int>? subjectId,
    Expression<String>? animeJson,
    Expression<DateTime>? addedAt,
  }) {
    return RawValuesInsertable({
      if (subjectId != null) 'subject_id': subjectId,
      if (animeJson != null) 'anime_json': animeJson,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  FavoritesCompanion copyWith({
    Value<int>? subjectId,
    Value<String>? animeJson,
    Value<DateTime>? addedAt,
  }) {
    return FavoritesCompanion(
      subjectId: subjectId ?? this.subjectId,
      animeJson: animeJson ?? this.animeJson,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (animeJson.present) {
      map['anime_json'] = Variable<String>(animeJson.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('subjectId: $subjectId, ')
          ..write('animeJson: $animeJson, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $WatchRecordsTable extends WatchRecords
    with TableInfo<$WatchRecordsTable, WatchRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WatchRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _episodeIdMeta = const VerificationMeta(
    'episodeId',
  );
  @override
  late final GeneratedColumn<int> episodeId = GeneratedColumn<int>(
    'episode_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _animeJsonMeta = const VerificationMeta(
    'animeJson',
  );
  @override
  late final GeneratedColumn<String> animeJson = GeneratedColumn<String>(
    'anime_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeTitleMeta = const VerificationMeta(
    'episodeTitle',
  );
  @override
  late final GeneratedColumn<String> episodeTitle = GeneratedColumn<String>(
    'episode_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeSortMeta = const VerificationMeta(
    'episodeSort',
  );
  @override
  late final GeneratedColumn<double> episodeSort = GeneratedColumn<double>(
    'episode_sort',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeTypeMeta = const VerificationMeta(
    'episodeType',
  );
  @override
  late final GeneratedColumn<int> episodeType = GeneratedColumn<int>(
    'episode_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMsMeta = const VerificationMeta(
    'positionMs',
  );
  @override
  late final GeneratedColumn<int> positionMs = GeneratedColumn<int>(
    'position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    episodeId,
    subjectId,
    animeJson,
    episodeTitle,
    episodeSort,
    episodeType,
    positionMs,
    durationMs,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'watch_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<WatchRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('episode_id')) {
      context.handle(
        _episodeIdMeta,
        episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta),
      );
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('anime_json')) {
      context.handle(
        _animeJsonMeta,
        animeJson.isAcceptableOrUnknown(data['anime_json']!, _animeJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_animeJsonMeta);
    }
    if (data.containsKey('episode_title')) {
      context.handle(
        _episodeTitleMeta,
        episodeTitle.isAcceptableOrUnknown(
          data['episode_title']!,
          _episodeTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeTitleMeta);
    }
    if (data.containsKey('episode_sort')) {
      context.handle(
        _episodeSortMeta,
        episodeSort.isAcceptableOrUnknown(
          data['episode_sort']!,
          _episodeSortMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeSortMeta);
    }
    if (data.containsKey('episode_type')) {
      context.handle(
        _episodeTypeMeta,
        episodeType.isAcceptableOrUnknown(
          data['episode_type']!,
          _episodeTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_episodeTypeMeta);
    }
    if (data.containsKey('position_ms')) {
      context.handle(
        _positionMsMeta,
        positionMs.isAcceptableOrUnknown(data['position_ms']!, _positionMsMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMsMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {episodeId};
  @override
  WatchRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WatchRecord(
      episodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      )!,
      animeJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anime_json'],
      )!,
      episodeTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_title'],
      )!,
      episodeSort: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}episode_sort'],
      )!,
      episodeType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_type'],
      )!,
      positionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_ms'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WatchRecordsTable createAlias(String alias) {
    return $WatchRecordsTable(attachedDatabase, alias);
  }
}

class WatchRecord extends DataClass implements Insertable<WatchRecord> {
  final int episodeId;
  final int subjectId;
  final String animeJson;
  final String episodeTitle;
  final double episodeSort;
  final int episodeType;
  final int positionMs;
  final int durationMs;
  final DateTime updatedAt;
  const WatchRecord({
    required this.episodeId,
    required this.subjectId,
    required this.animeJson,
    required this.episodeTitle,
    required this.episodeSort,
    required this.episodeType,
    required this.positionMs,
    required this.durationMs,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['episode_id'] = Variable<int>(episodeId);
    map['subject_id'] = Variable<int>(subjectId);
    map['anime_json'] = Variable<String>(animeJson);
    map['episode_title'] = Variable<String>(episodeTitle);
    map['episode_sort'] = Variable<double>(episodeSort);
    map['episode_type'] = Variable<int>(episodeType);
    map['position_ms'] = Variable<int>(positionMs);
    map['duration_ms'] = Variable<int>(durationMs);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WatchRecordsCompanion toCompanion(bool nullToAbsent) {
    return WatchRecordsCompanion(
      episodeId: Value(episodeId),
      subjectId: Value(subjectId),
      animeJson: Value(animeJson),
      episodeTitle: Value(episodeTitle),
      episodeSort: Value(episodeSort),
      episodeType: Value(episodeType),
      positionMs: Value(positionMs),
      durationMs: Value(durationMs),
      updatedAt: Value(updatedAt),
    );
  }

  factory WatchRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WatchRecord(
      episodeId: serializer.fromJson<int>(json['episodeId']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      animeJson: serializer.fromJson<String>(json['animeJson']),
      episodeTitle: serializer.fromJson<String>(json['episodeTitle']),
      episodeSort: serializer.fromJson<double>(json['episodeSort']),
      episodeType: serializer.fromJson<int>(json['episodeType']),
      positionMs: serializer.fromJson<int>(json['positionMs']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'episodeId': serializer.toJson<int>(episodeId),
      'subjectId': serializer.toJson<int>(subjectId),
      'animeJson': serializer.toJson<String>(animeJson),
      'episodeTitle': serializer.toJson<String>(episodeTitle),
      'episodeSort': serializer.toJson<double>(episodeSort),
      'episodeType': serializer.toJson<int>(episodeType),
      'positionMs': serializer.toJson<int>(positionMs),
      'durationMs': serializer.toJson<int>(durationMs),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WatchRecord copyWith({
    int? episodeId,
    int? subjectId,
    String? animeJson,
    String? episodeTitle,
    double? episodeSort,
    int? episodeType,
    int? positionMs,
    int? durationMs,
    DateTime? updatedAt,
  }) => WatchRecord(
    episodeId: episodeId ?? this.episodeId,
    subjectId: subjectId ?? this.subjectId,
    animeJson: animeJson ?? this.animeJson,
    episodeTitle: episodeTitle ?? this.episodeTitle,
    episodeSort: episodeSort ?? this.episodeSort,
    episodeType: episodeType ?? this.episodeType,
    positionMs: positionMs ?? this.positionMs,
    durationMs: durationMs ?? this.durationMs,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WatchRecord copyWithCompanion(WatchRecordsCompanion data) {
    return WatchRecord(
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      animeJson: data.animeJson.present ? data.animeJson.value : this.animeJson,
      episodeTitle: data.episodeTitle.present
          ? data.episodeTitle.value
          : this.episodeTitle,
      episodeSort: data.episodeSort.present
          ? data.episodeSort.value
          : this.episodeSort,
      episodeType: data.episodeType.present
          ? data.episodeType.value
          : this.episodeType,
      positionMs: data.positionMs.present
          ? data.positionMs.value
          : this.positionMs,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WatchRecord(')
          ..write('episodeId: $episodeId, ')
          ..write('subjectId: $subjectId, ')
          ..write('animeJson: $animeJson, ')
          ..write('episodeTitle: $episodeTitle, ')
          ..write('episodeSort: $episodeSort, ')
          ..write('episodeType: $episodeType, ')
          ..write('positionMs: $positionMs, ')
          ..write('durationMs: $durationMs, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    episodeId,
    subjectId,
    animeJson,
    episodeTitle,
    episodeSort,
    episodeType,
    positionMs,
    durationMs,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WatchRecord &&
          other.episodeId == this.episodeId &&
          other.subjectId == this.subjectId &&
          other.animeJson == this.animeJson &&
          other.episodeTitle == this.episodeTitle &&
          other.episodeSort == this.episodeSort &&
          other.episodeType == this.episodeType &&
          other.positionMs == this.positionMs &&
          other.durationMs == this.durationMs &&
          other.updatedAt == this.updatedAt);
}

class WatchRecordsCompanion extends UpdateCompanion<WatchRecord> {
  final Value<int> episodeId;
  final Value<int> subjectId;
  final Value<String> animeJson;
  final Value<String> episodeTitle;
  final Value<double> episodeSort;
  final Value<int> episodeType;
  final Value<int> positionMs;
  final Value<int> durationMs;
  final Value<DateTime> updatedAt;
  const WatchRecordsCompanion({
    this.episodeId = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.animeJson = const Value.absent(),
    this.episodeTitle = const Value.absent(),
    this.episodeSort = const Value.absent(),
    this.episodeType = const Value.absent(),
    this.positionMs = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WatchRecordsCompanion.insert({
    this.episodeId = const Value.absent(),
    required int subjectId,
    required String animeJson,
    required String episodeTitle,
    required double episodeSort,
    required int episodeType,
    required int positionMs,
    required int durationMs,
    required DateTime updatedAt,
  }) : subjectId = Value(subjectId),
       animeJson = Value(animeJson),
       episodeTitle = Value(episodeTitle),
       episodeSort = Value(episodeSort),
       episodeType = Value(episodeType),
       positionMs = Value(positionMs),
       durationMs = Value(durationMs),
       updatedAt = Value(updatedAt);
  static Insertable<WatchRecord> custom({
    Expression<int>? episodeId,
    Expression<int>? subjectId,
    Expression<String>? animeJson,
    Expression<String>? episodeTitle,
    Expression<double>? episodeSort,
    Expression<int>? episodeType,
    Expression<int>? positionMs,
    Expression<int>? durationMs,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (episodeId != null) 'episode_id': episodeId,
      if (subjectId != null) 'subject_id': subjectId,
      if (animeJson != null) 'anime_json': animeJson,
      if (episodeTitle != null) 'episode_title': episodeTitle,
      if (episodeSort != null) 'episode_sort': episodeSort,
      if (episodeType != null) 'episode_type': episodeType,
      if (positionMs != null) 'position_ms': positionMs,
      if (durationMs != null) 'duration_ms': durationMs,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WatchRecordsCompanion copyWith({
    Value<int>? episodeId,
    Value<int>? subjectId,
    Value<String>? animeJson,
    Value<String>? episodeTitle,
    Value<double>? episodeSort,
    Value<int>? episodeType,
    Value<int>? positionMs,
    Value<int>? durationMs,
    Value<DateTime>? updatedAt,
  }) {
    return WatchRecordsCompanion(
      episodeId: episodeId ?? this.episodeId,
      subjectId: subjectId ?? this.subjectId,
      animeJson: animeJson ?? this.animeJson,
      episodeTitle: episodeTitle ?? this.episodeTitle,
      episodeSort: episodeSort ?? this.episodeSort,
      episodeType: episodeType ?? this.episodeType,
      positionMs: positionMs ?? this.positionMs,
      durationMs: durationMs ?? this.durationMs,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (episodeId.present) {
      map['episode_id'] = Variable<int>(episodeId.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (animeJson.present) {
      map['anime_json'] = Variable<String>(animeJson.value);
    }
    if (episodeTitle.present) {
      map['episode_title'] = Variable<String>(episodeTitle.value);
    }
    if (episodeSort.present) {
      map['episode_sort'] = Variable<double>(episodeSort.value);
    }
    if (episodeType.present) {
      map['episode_type'] = Variable<int>(episodeType.value);
    }
    if (positionMs.present) {
      map['position_ms'] = Variable<int>(positionMs.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WatchRecordsCompanion(')
          ..write('episodeId: $episodeId, ')
          ..write('subjectId: $subjectId, ')
          ..write('animeJson: $animeJson, ')
          ..write('episodeTitle: $episodeTitle, ')
          ..write('episodeSort: $episodeSort, ')
          ..write('episodeType: $episodeType, ')
          ..write('positionMs: $positionMs, ')
          ..write('durationMs: $durationMs, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MediaBindingsTable extends MediaBindings
    with TableInfo<$MediaBindingsTable, MediaBinding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaBindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _episodeIdMeta = const VerificationMeta(
    'episodeId',
  );
  @override
  late final GeneratedColumn<int> episodeId = GeneratedColumn<int>(
    'episode_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
    'uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headersJsonMeta = const VerificationMeta(
    'headersJson',
  );
  @override
  late final GeneratedColumn<String> headersJson = GeneratedColumn<String>(
    'headers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _sourceBindingJsonMeta = const VerificationMeta(
    'sourceBindingJson',
  );
  @override
  late final GeneratedColumn<String> sourceBindingJson =
      GeneratedColumn<String>(
        'source_binding_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    episodeId,
    uri,
    headersJson,
    sourceBindingJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_bindings';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaBinding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('episode_id')) {
      context.handle(
        _episodeIdMeta,
        episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta),
      );
    }
    if (data.containsKey('uri')) {
      context.handle(
        _uriMeta,
        uri.isAcceptableOrUnknown(data['uri']!, _uriMeta),
      );
    } else if (isInserting) {
      context.missing(_uriMeta);
    }
    if (data.containsKey('headers_json')) {
      context.handle(
        _headersJsonMeta,
        headersJson.isAcceptableOrUnknown(
          data['headers_json']!,
          _headersJsonMeta,
        ),
      );
    }
    if (data.containsKey('source_binding_json')) {
      context.handle(
        _sourceBindingJsonMeta,
        sourceBindingJson.isAcceptableOrUnknown(
          data['source_binding_json']!,
          _sourceBindingJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {episodeId};
  @override
  MediaBinding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaBinding(
      episodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episode_id'],
      )!,
      uri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uri'],
      )!,
      headersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}headers_json'],
      )!,
      sourceBindingJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_binding_json'],
      ),
    );
  }

  @override
  $MediaBindingsTable createAlias(String alias) {
    return $MediaBindingsTable(attachedDatabase, alias);
  }
}

class MediaBinding extends DataClass implements Insertable<MediaBinding> {
  final int episodeId;
  final String uri;
  final String headersJson;
  final String? sourceBindingJson;
  const MediaBinding({
    required this.episodeId,
    required this.uri,
    required this.headersJson,
    this.sourceBindingJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['episode_id'] = Variable<int>(episodeId);
    map['uri'] = Variable<String>(uri);
    map['headers_json'] = Variable<String>(headersJson);
    if (!nullToAbsent || sourceBindingJson != null) {
      map['source_binding_json'] = Variable<String>(sourceBindingJson);
    }
    return map;
  }

  MediaBindingsCompanion toCompanion(bool nullToAbsent) {
    return MediaBindingsCompanion(
      episodeId: Value(episodeId),
      uri: Value(uri),
      headersJson: Value(headersJson),
      sourceBindingJson: sourceBindingJson == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceBindingJson),
    );
  }

  factory MediaBinding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaBinding(
      episodeId: serializer.fromJson<int>(json['episodeId']),
      uri: serializer.fromJson<String>(json['uri']),
      headersJson: serializer.fromJson<String>(json['headersJson']),
      sourceBindingJson: serializer.fromJson<String?>(
        json['sourceBindingJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'episodeId': serializer.toJson<int>(episodeId),
      'uri': serializer.toJson<String>(uri),
      'headersJson': serializer.toJson<String>(headersJson),
      'sourceBindingJson': serializer.toJson<String?>(sourceBindingJson),
    };
  }

  MediaBinding copyWith({
    int? episodeId,
    String? uri,
    String? headersJson,
    Value<String?> sourceBindingJson = const Value.absent(),
  }) => MediaBinding(
    episodeId: episodeId ?? this.episodeId,
    uri: uri ?? this.uri,
    headersJson: headersJson ?? this.headersJson,
    sourceBindingJson: sourceBindingJson.present
        ? sourceBindingJson.value
        : this.sourceBindingJson,
  );
  MediaBinding copyWithCompanion(MediaBindingsCompanion data) {
    return MediaBinding(
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      uri: data.uri.present ? data.uri.value : this.uri,
      headersJson: data.headersJson.present
          ? data.headersJson.value
          : this.headersJson,
      sourceBindingJson: data.sourceBindingJson.present
          ? data.sourceBindingJson.value
          : this.sourceBindingJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaBinding(')
          ..write('episodeId: $episodeId, ')
          ..write('uri: $uri, ')
          ..write('headersJson: $headersJson, ')
          ..write('sourceBindingJson: $sourceBindingJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(episodeId, uri, headersJson, sourceBindingJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaBinding &&
          other.episodeId == this.episodeId &&
          other.uri == this.uri &&
          other.headersJson == this.headersJson &&
          other.sourceBindingJson == this.sourceBindingJson);
}

class MediaBindingsCompanion extends UpdateCompanion<MediaBinding> {
  final Value<int> episodeId;
  final Value<String> uri;
  final Value<String> headersJson;
  final Value<String?> sourceBindingJson;
  const MediaBindingsCompanion({
    this.episodeId = const Value.absent(),
    this.uri = const Value.absent(),
    this.headersJson = const Value.absent(),
    this.sourceBindingJson = const Value.absent(),
  });
  MediaBindingsCompanion.insert({
    this.episodeId = const Value.absent(),
    required String uri,
    this.headersJson = const Value.absent(),
    this.sourceBindingJson = const Value.absent(),
  }) : uri = Value(uri);
  static Insertable<MediaBinding> custom({
    Expression<int>? episodeId,
    Expression<String>? uri,
    Expression<String>? headersJson,
    Expression<String>? sourceBindingJson,
  }) {
    return RawValuesInsertable({
      if (episodeId != null) 'episode_id': episodeId,
      if (uri != null) 'uri': uri,
      if (headersJson != null) 'headers_json': headersJson,
      if (sourceBindingJson != null) 'source_binding_json': sourceBindingJson,
    });
  }

  MediaBindingsCompanion copyWith({
    Value<int>? episodeId,
    Value<String>? uri,
    Value<String>? headersJson,
    Value<String?>? sourceBindingJson,
  }) {
    return MediaBindingsCompanion(
      episodeId: episodeId ?? this.episodeId,
      uri: uri ?? this.uri,
      headersJson: headersJson ?? this.headersJson,
      sourceBindingJson: sourceBindingJson ?? this.sourceBindingJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (episodeId.present) {
      map['episode_id'] = Variable<int>(episodeId.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (headersJson.present) {
      map['headers_json'] = Variable<String>(headersJson.value);
    }
    if (sourceBindingJson.present) {
      map['source_binding_json'] = Variable<String>(sourceBindingJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaBindingsCompanion(')
          ..write('episodeId: $episodeId, ')
          ..write('uri: $uri, ')
          ..write('headersJson: $headersJson, ')
          ..write('sourceBindingJson: $sourceBindingJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $WatchRecordsTable watchRecords = $WatchRecordsTable(this);
  late final $MediaBindingsTable mediaBindings = $MediaBindingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    favorites,
    watchRecords,
    mediaBindings,
  ];
}

typedef $$FavoritesTableCreateCompanionBuilder = FavoritesCompanion Function({
  Value<int> subjectId,
  required String animeJson,
  required DateTime addedAt,
});
typedef $$FavoritesTableUpdateCompanionBuilder = FavoritesCompanion Function({
  Value<int> subjectId,
  Value<String> animeJson,
  Value<DateTime> addedAt,
});

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animeJson => $composableBuilder(
    column: $table.animeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animeJson => $composableBuilder(
    column: $table.animeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get animeJson =>
      $composableBuilder(column: $table.animeJson, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTable,
          Favorite,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
          Favorite,
          PrefetchHooks Function()
        > {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> subjectId = const Value.absent(),
                Value<String> animeJson = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
              }) => FavoritesCompanion(
                subjectId: subjectId,
                animeJson: animeJson,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> subjectId = const Value.absent(),
                required String animeJson,
                required DateTime addedAt,
              }) => FavoritesCompanion.insert(
                subjectId: subjectId,
                animeJson: animeJson,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FavoritesTable, Favorite>(table),
                  BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTable,
      Favorite,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (Favorite, BaseReferences<_$AppDatabase, $FavoritesTable, Favorite>),
      Favorite,
      PrefetchHooks Function()
    >;
typedef $$WatchRecordsTableCreateCompanionBuilder =
    WatchRecordsCompanion Function({
      Value<int> episodeId,
      required int subjectId,
      required String animeJson,
      required String episodeTitle,
      required double episodeSort,
      required int episodeType,
      required int positionMs,
      required int durationMs,
      required DateTime updatedAt,
    });
typedef $$WatchRecordsTableUpdateCompanionBuilder =
    WatchRecordsCompanion Function({
      Value<int> episodeId,
      Value<int> subjectId,
      Value<String> animeJson,
      Value<String> episodeTitle,
      Value<double> episodeSort,
      Value<int> episodeType,
      Value<int> positionMs,
      Value<int> durationMs,
      Value<DateTime> updatedAt,
    });

class $$WatchRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $WatchRecordsTable> {
  $$WatchRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get animeJson => $composableBuilder(
    column: $table.animeJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeTitle => $composableBuilder(
    column: $table.episodeTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get episodeSort => $composableBuilder(
    column: $table.episodeSort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episodeType => $composableBuilder(
    column: $table.episodeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WatchRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WatchRecordsTable> {
  $$WatchRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subjectId => $composableBuilder(
    column: $table.subjectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get animeJson => $composableBuilder(
    column: $table.animeJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeTitle => $composableBuilder(
    column: $table.episodeTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get episodeSort => $composableBuilder(
    column: $table.episodeSort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episodeType => $composableBuilder(
    column: $table.episodeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WatchRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WatchRecordsTable> {
  $$WatchRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<int> get subjectId =>
      $composableBuilder(column: $table.subjectId, builder: (column) => column);

  GeneratedColumn<String> get animeJson =>
      $composableBuilder(column: $table.animeJson, builder: (column) => column);

  GeneratedColumn<String> get episodeTitle => $composableBuilder(
    column: $table.episodeTitle,
    builder: (column) => column,
  );

  GeneratedColumn<double> get episodeSort => $composableBuilder(
    column: $table.episodeSort,
    builder: (column) => column,
  );

  GeneratedColumn<int> get episodeType => $composableBuilder(
    column: $table.episodeType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WatchRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WatchRecordsTable,
          WatchRecord,
          $$WatchRecordsTableFilterComposer,
          $$WatchRecordsTableOrderingComposer,
          $$WatchRecordsTableAnnotationComposer,
          $$WatchRecordsTableCreateCompanionBuilder,
          $$WatchRecordsTableUpdateCompanionBuilder,
          (
            WatchRecord,
            BaseReferences<_$AppDatabase, $WatchRecordsTable, WatchRecord>,
          ),
          WatchRecord,
          PrefetchHooks Function()
        > {
  $$WatchRecordsTableTableManager(_$AppDatabase db, $WatchRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WatchRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WatchRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WatchRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> episodeId = const Value.absent(),
                Value<int> subjectId = const Value.absent(),
                Value<String> animeJson = const Value.absent(),
                Value<String> episodeTitle = const Value.absent(),
                Value<double> episodeSort = const Value.absent(),
                Value<int> episodeType = const Value.absent(),
                Value<int> positionMs = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => WatchRecordsCompanion(
                episodeId: episodeId,
                subjectId: subjectId,
                animeJson: animeJson,
                episodeTitle: episodeTitle,
                episodeSort: episodeSort,
                episodeType: episodeType,
                positionMs: positionMs,
                durationMs: durationMs,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> episodeId = const Value.absent(),
                required int subjectId,
                required String animeJson,
                required String episodeTitle,
                required double episodeSort,
                required int episodeType,
                required int positionMs,
                required int durationMs,
                required DateTime updatedAt,
              }) => WatchRecordsCompanion.insert(
                episodeId: episodeId,
                subjectId: subjectId,
                animeJson: animeJson,
                episodeTitle: episodeTitle,
                episodeSort: episodeSort,
                episodeType: episodeType,
                positionMs: positionMs,
                durationMs: durationMs,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WatchRecordsTable, WatchRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WatchRecordsTable,
                    WatchRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WatchRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WatchRecordsTable,
      WatchRecord,
      $$WatchRecordsTableFilterComposer,
      $$WatchRecordsTableOrderingComposer,
      $$WatchRecordsTableAnnotationComposer,
      $$WatchRecordsTableCreateCompanionBuilder,
      $$WatchRecordsTableUpdateCompanionBuilder,
      (
        WatchRecord,
        BaseReferences<_$AppDatabase, $WatchRecordsTable, WatchRecord>,
      ),
      WatchRecord,
      PrefetchHooks Function()
    >;
typedef $$MediaBindingsTableCreateCompanionBuilder =
    MediaBindingsCompanion Function({
      Value<int> episodeId,
      required String uri,
      Value<String> headersJson,
      Value<String?> sourceBindingJson,
    });
typedef $$MediaBindingsTableUpdateCompanionBuilder =
    MediaBindingsCompanion Function({
      Value<int> episodeId,
      Value<String> uri,
      Value<String> headersJson,
      Value<String?> sourceBindingJson,
    });

class $$MediaBindingsTableFilterComposer
    extends Composer<_$AppDatabase, $MediaBindingsTable> {
  $$MediaBindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headersJson => $composableBuilder(
    column: $table.headersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceBindingJson => $composableBuilder(
    column: $table.sourceBindingJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaBindingsTableOrderingComposer
    extends Composer<_$AppDatabase, $MediaBindingsTable> {
  $$MediaBindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headersJson => $composableBuilder(
    column: $table.headersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceBindingJson => $composableBuilder(
    column: $table.sourceBindingJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaBindingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MediaBindingsTable> {
  $$MediaBindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<String> get headersJson => $composableBuilder(
    column: $table.headersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceBindingJson => $composableBuilder(
    column: $table.sourceBindingJson,
    builder: (column) => column,
  );
}

class $$MediaBindingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MediaBindingsTable,
          MediaBinding,
          $$MediaBindingsTableFilterComposer,
          $$MediaBindingsTableOrderingComposer,
          $$MediaBindingsTableAnnotationComposer,
          $$MediaBindingsTableCreateCompanionBuilder,
          $$MediaBindingsTableUpdateCompanionBuilder,
          (
            MediaBinding,
            BaseReferences<_$AppDatabase, $MediaBindingsTable, MediaBinding>,
          ),
          MediaBinding,
          PrefetchHooks Function()
        > {
  $$MediaBindingsTableTableManager(_$AppDatabase db, $MediaBindingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaBindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaBindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaBindingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> episodeId = const Value.absent(),
                Value<String> uri = const Value.absent(),
                Value<String> headersJson = const Value.absent(),
                Value<String?> sourceBindingJson = const Value.absent(),
              }) => MediaBindingsCompanion(
                episodeId: episodeId,
                uri: uri,
                headersJson: headersJson,
                sourceBindingJson: sourceBindingJson,
              ),
          createCompanionCallback:
              ({
                Value<int> episodeId = const Value.absent(),
                required String uri,
                Value<String> headersJson = const Value.absent(),
                Value<String?> sourceBindingJson = const Value.absent(),
              }) => MediaBindingsCompanion.insert(
                episodeId: episodeId,
                uri: uri,
                headersJson: headersJson,
                sourceBindingJson: sourceBindingJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MediaBindingsTable, MediaBinding>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MediaBindingsTable,
                    MediaBinding
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaBindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MediaBindingsTable,
      MediaBinding,
      $$MediaBindingsTableFilterComposer,
      $$MediaBindingsTableOrderingComposer,
      $$MediaBindingsTableAnnotationComposer,
      $$MediaBindingsTableCreateCompanionBuilder,
      $$MediaBindingsTableUpdateCompanionBuilder,
      (
        MediaBinding,
        BaseReferences<_$AppDatabase, $MediaBindingsTable, MediaBinding>,
      ),
      MediaBinding,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$WatchRecordsTableTableManager get watchRecords =>
      $$WatchRecordsTableTableManager(_db, _db.watchRecords);
  $$MediaBindingsTableTableManager get mediaBindings =>
      $$MediaBindingsTableTableManager(_db, _db.mediaBindings);
}
