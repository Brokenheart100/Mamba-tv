import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/logging.dart';
import '../../../domain/bangumi_discovery.dart';

typedef SubjectExtrasState = ({
  AsyncValue<List<RelatedAnime>> relations,
  AsyncValue<List<AnimeCharacter>> characters,
});

class SubjectExtrasViewModel extends Notifier<SubjectExtrasState> {
  SubjectExtrasViewModel(this.subjectId);
  final int subjectId;
  int _relationsGeneration = 0;
  int _charactersGeneration = 0;
  @override
  SubjectExtrasState build() {
    if (ref.read(bangumiDiscoveryRepositoryProvider) == null) {
      return (relations: const AsyncData([]), characters: const AsyncData([]));
    }
    unawaited(
      Future.microtask(() {
        if (!ref.mounted) return;
        unawaited(loadRelations());
        unawaited(loadCharacters());
      }),
    );
    return (relations: const AsyncLoading(), characters: const AsyncLoading());
  }

  Future<void> loadRelations() async {
    final generation = ++_relationsGeneration;
    state = (relations: const AsyncLoading(), characters: state.characters);
    try {
      final rows = await ref
          .read(bangumiDiscoveryRepositoryProvider)!
          .relations(subjectId);
      if (ref.mounted && generation == _relationsGeneration) {
        state = (relations: AsyncData(rows), characters: state.characters);
      }
    } catch (error, stack) {
      if (!ref.mounted || generation != _relationsGeneration) return;
      logFailure(ref.read(talkerProvider), '加载系列作品', error, stack);
      state = (
        relations: AsyncError(error, stack),
        characters: state.characters,
      );
    }
  }

  Future<void> loadCharacters() async {
    final generation = ++_charactersGeneration;
    state = (relations: state.relations, characters: const AsyncLoading());
    try {
      final rows = await ref
          .read(bangumiDiscoveryRepositoryProvider)!
          .characters(subjectId);
      if (ref.mounted && generation == _charactersGeneration) {
        state = (relations: state.relations, characters: AsyncData(rows));
      }
    } catch (error, stack) {
      if (!ref.mounted || generation != _charactersGeneration) return;
      logFailure(ref.read(talkerProvider), '加载角色声优', error, stack);
      state = (
        relations: state.relations,
        characters: AsyncError(error, stack),
      );
    }
  }
}

final subjectExtrasViewModelProvider = NotifierProvider.autoDispose
    .family<SubjectExtrasViewModel, SubjectExtrasState, int>(
      SubjectExtrasViewModel.new,
    );
