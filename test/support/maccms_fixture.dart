import 'package:mamba_tv/domain/video_source.dart';

const configuredSource = VideoSource(
  id: 'test',
  name: '测试源',
  endpoint: 'https://example.com/api.php/provide/vod/?key=private',
);

Map<String, dynamic> macCmsList({int page = 1}) => {
  'code': 1,
  'page': '$page',
  'pagecount': 2,
  'limit': 20,
  'total': 2,
  'list': [
    {
      'vod_id': page == 1 ? 7 : 8,
      'vod_name': '示例资源 $page',
      'type_name': '动漫',
      'vod_remarks': '全2集',
      'vod_year': '2024',
    },
  ],
};

Map<String, dynamic> macCmsDetail({String from = r'hls$$$web'}) => {
  'code': 1,
  'page': 1,
  'pagecount': 1,
  'total': 1,
  'list': [
    {
      'vod_id': 7,
      'vod_name': '示例资源 1',
      'vod_play_from': from,
      'vod_play_url': r'第1集$https://example.com/1.m3u8?token=test-secret#第2集$https://example.com/2.mp4$$$网页集$https://example.com/watch/7.html',
    },
  ],
};
