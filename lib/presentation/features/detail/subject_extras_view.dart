import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../domain/bangumi_discovery.dart';
import '../../core/anime_card.dart';
import '../../core/error_message.dart';
import '../../core/page_parts.dart';
import '../../core/tv_focus.dart';
import 'subject_extras_view_model.dart';

class SubjectExtrasView extends ConsumerWidget {
  const SubjectExtrasView({super.key, required this.subjectId});
  final int subjectId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(bangumiDiscoveryRepositoryProvider) == null) {
      return const SizedBox.shrink();
    }
    final value = ref.watch(subjectExtrasViewModelProvider(subjectId));
    final vm = ref.read(subjectExtrasViewModelProvider(subjectId).notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(34, 24, 34, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading('系列作品', '前传、续作与其他关联动画'),
          value.relations.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => _SectionFailure(
              message: '系列作品暂时无法加载：${errorMessage(error)}',
              onRetry: vm.loadRelations,
            ),
            data: (rows) => rows.isEmpty
                ? const Text('暂无关联动画资料', style: TextStyle(color: muted))
                : SizedBox(
                    height: 270,
                    child: ListView.separated(
                      key: PageStorageKey(('relations', subjectId)),
                      scrollDirection: Axis.horizontal,
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => SizedBox(
                        width: 165,
                        child: AnimeCard(
                          anime: rows[index].anime,
                          subtitle: rows[index].relation,
                          onPressed: () =>
                              context.push('/anime/${rows[index].anime.id}'),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 24),
          const PageHeading('角色与声优', '角色及配音演员资料来自 Bangumi'),
          value.characters.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => _SectionFailure(
              message: '角色资料暂时无法加载：${errorMessage(error)}',
              onRetry: vm.loadCharacters,
            ),
            data: (rows) => rows.isEmpty
                ? const Text('暂无角色与声优资料', style: TextStyle(color: muted))
                : SizedBox(
                    height: 265,
                    child: ListView.separated(
                      key: PageStorageKey(('characters', subjectId)),
                      scrollDirection: Axis.horizontal,
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) =>
                          _CharacterCard(character: rows[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SectionFailure extends StatelessWidget {
  const _SectionFailure({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 10,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      Text(message, style: const TextStyle(color: muted)),
      TvButton(label: '重试', icon: Icons.refresh, onPressed: onRetry),
    ],
  );
}

class _CharacterCard extends StatelessWidget {
  const _CharacterCard({required this.character});
  final AnimeCharacter character;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 175,
    child: TvFocus(
      label: character.name,
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(character.name),
          content: SingleChildScrollView(
            child: Text(
              '${character.relation}\n\n配音演员\n${character.actors.isEmpty ? '暂无配音资料' : character.actors.map((actor) => actor.name).join('\n')}',
            ),
          ),
          actions: [
            TextButton(
              autofocus: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
          ],
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: SizedBox(
                width: double.infinity,
                child: CatalogImage(
                  image: character.image,
                  seed: character.id,
                  icon: Icons.person_outline,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            character.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            character.relation,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: muted, fontSize: 12),
          ),
          Text(
            character.actors.isEmpty
                ? '暂无配音资料'
                : 'CV：${character.actors.map((actor) => actor.name).join(' / ')}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}
