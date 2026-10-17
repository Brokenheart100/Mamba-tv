import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
part 'app_database.g.dart';

class Favorites extends Table {
  IntColumn get subjectId => integer()();
  TextColumn get animeJson => text()();
  DateTimeColumn get addedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {subjectId};
}

class WatchRecords extends Table {
  IntColumn get episodeId => integer()();
  IntColumn get subjectId => integer()();
  TextColumn get animeJson => text()();
  TextColumn get episodeTitle => text()();
  RealColumn get episodeSort => real()();
  IntColumn get episodeType => integer()();
  IntColumn get positionMs => integer()();
  IntColumn get durationMs => integer()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {episodeId};
}

class MediaBindings extends Table {
  IntColumn get episodeId => integer()();
  TextColumn get uri => text()();
  TextColumn get headersJson => text().withDefault(const Constant('{}'))();
  TextColumn get sourceBindingJson => text().nullable()();
  @override
  Set<Column> get primaryKey => {episodeId};
}

@DriftDatabase(tables: [Favorites, WatchRecords, MediaBindings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);
  AppDatabase.defaults() : super(driftDatabase(name: 'mamba_tv'));
  @override
  int get schemaVersion => 2;
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(mediaBindings, mediaBindings.headersJson);
        await migrator.addColumn(
          mediaBindings,
          mediaBindings.sourceBindingJson,
        );
      }
    },
  );
}
