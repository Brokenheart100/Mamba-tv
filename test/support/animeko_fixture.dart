import 'package:mamba_tv/domain/video_source.dart';

final selectorSource = VideoSource(
  id: 'animeko:web-selector:test',
  name: '规则测试源',
  endpoint: 'https://example.com/search?wd={keyword}',
  factoryId: 'web-selector',
  arguments: {
    'searchConfig': {
      'searchUrl': 'https://example.com/search?wd={keyword}',
      'requestInterval': 0,
      'subjectFormatId': 'a',
      'selectorSubjectFormatA': {'selectLists': '.results a'},
      'channelFormatId': 'index-grouped',
      'selectorChannelFormatFlattened': {
        'selectChannelNames': '.tabs span',
        'matchChannelName': r'^(?<ch>主线|备用)',
        'selectEpisodeLists': '.episodes',
        'selectEpisodesFromList': 'a',
      },
      'matchVideo': {
        'enableNestedUrl': true,
        'matchNestedUrl': r'parser\?',
        'matchVideoUrl': r'url=(?<v>https://[^&]+\.m3u8)|\.m3u8(\?|$)',
      },
    },
  },
);

final jsonApiSource = VideoSource(
  id: 'animeko:json-api:test',
  name: 'API 规则测试源',
  endpoint: 'https://example.com',
  factoryId: 'json-api',
  arguments: {
    'searchConfig': {
      'baseUrl': 'https://example.com',
      'headers': 'apikey: fixture-key',
      'requestInterval': 0,
      'search': {
        'request': {
          'url': '/search',
          'method': 'POST',
          'body': r'{"term":"{keyword}","page":{page},"size":{pageSize}}',
        },
        'pageSize': 50,
        'selectItems': r'$[*]',
        'selectName': r'$.title',
        'selectId': r'$.id',
      },
      'subject': {
        'request': {'url': '/detail', 'method': 'POST', 'body': r'{"id":{id}}'},
        'channelFormatId': 'grouped',
        'channelFormatGrouped': {
          'selectChannels': r'$.sources[*]',
          'selectChannelName': r'$.name',
        },
        'episodes': {
          'selectEpisodes': r'$.episodes[*]',
          'selectName': r'$.title',
          'selectId': r'$.id',
          'selectSort': r'$.number',
        },
      },
      'play': {
        'request': {
          'url': '/play',
          'method': 'POST',
          'body': r'{"episode":{id}}',
        },
        'selectCandidates': r'$.candidates[*]',
        'selectCandidateChannel': r'$.channel',
        'selectVideoUrl': r'$.url',
        'fallbackToFirstCandidate': false,
      },
    },
  },
);

Map<String, dynamic> animekoSubscription({bool includeWeb = true}) => {
  'schemaVersion': 2,
  'mediaSources': [
    if (includeWeb)
      {
        'id': 'test-web',
        'factoryId': 'web-selector',
        'arguments': {'name': '规则测试源', ...selectorSource.arguments},
      },
    {
      'id': 'test-json',
      'factoryId': 'json-api',
      'arguments': {'name': 'API 规则测试源', ...jsonApiSource.arguments},
    },
  ],
};
