import 'package:mamba_tv/domain/bangumi_discovery.dart';
import 'package:mamba_tv/domain/models.dart';

import 'fakes.dart';

const relatedAnime = Anime(id: 2, title: '测试番剧续作');
const testCharacter = AnimeCharacter(
  id: 10,
  name: '测试角色',
  relation: '主角',
  actors: [VoiceActor(id: 20, name: '测试声优')],
);

class FakeDiscovery implements BangumiDiscoveryRepository {
  final queries = <({BrowseQuery query, int offset})>[];
  int calendarCalls = 0;
  final relationCalls = <int>[];
  final characterCalls = <int>[];
  @override
  Future<List<BroadcastDay>> calendar() async {
    calendarCalls++;
    return List.generate(
      7,
      (index) => BroadcastDay(
        weekday: index + 1,
        items: [testAnime.copyWith(title: '周${index + 1}番剧')],
      ),
    );
  }

  @override
  Future<AnimePage> browse(BrowseQuery query, {int offset = 0}) async {
    queries.add((query: query, offset: offset));
    return const AnimePage([testAnime], 1);
  }

  @override
  Future<List<RelatedAnime>> relations(int subjectId) async {
    relationCalls.add(subjectId);
    return [
      RelatedAnime(
        anime: subjectId == 2 ? testAnime : relatedAnime,
        relation: subjectId == 2 ? '前传' : '续集',
      ),
    ];
  }

  @override
  Future<List<AnimeCharacter>> characters(int subjectId) async {
    characterCalls.add(subjectId);
    return [testCharacter];
  }
}
