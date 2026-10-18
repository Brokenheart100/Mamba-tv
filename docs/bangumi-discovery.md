# Bangumi 周历、季度与详情扩展

这批功能使用公开资料，不需要 Bangumi 账号。侧栏「新番周历」进入 `/calendar`，「新番与榜单」进入 `/browse`；番剧详情增加「系列作品」「角色与声优」。视频源和弹幕服务仍走现有独立流程。

## 接口和行为

| 功能 | 请求 | 处理方式 |
| --- | --- | --- |
| 周历 | `GET /calendar` | 保留 weekday.id 1—7；同一天重复条目合并，跨天出现保留；缺失星期显示空列表。切换星期不重新请求，刷新按钮重新读取。放送日不承诺资源站的视频更新时间。 |
| 季度新番 | `POST /v0/search/subjects` | 动画 type=2、nsfw=false，首播日期从季度首日起到下一季度首日前，支持热度 / 排名 / 评分排序。第四季度正确跨年。形式筛选使用社区标签，受条目标签完整度影响。 |
| 综合榜单 | `GET /v0/subjects` | type=2、sort=rank，年份可选，cat 使用官方分类值 TV=1、OVA=2、Movie=3、WEB=5；全部形式不发送 cat。 |
| 系列作品 | `GET /v0/subjects/{id}/subjects` | 展示原始 relation 标签，仅动画类型可进入现有番剧详情，不把原作书籍或游戏当成动画。去除当前条目和重复 ID，不猜测观看顺序或拼接额外季度。 |
| 角色声优 | `GET /v0/subjects/{id}/characters` | 直接使用内嵌 actors；不为每个角色额外请求。无图走缓存图片组件的占位图；无演员显示暂无配音资料，确认角色卡片可查看完整演员名称列表。 |

分页使用服务端实际返回数量推进 offset（搜索接口可能少于请求的 24 条），结果按 ID 去重；空页终止继续加载。快速改变筛选条件后，旧查询 / 旧分页响应不能覆盖新结果。分页失败保留已加载内容并重试原 offset。

系列和角色分别处理加载、空数据、错误与重试，不阻塞选集及原有播放；局部错误的重试按钮不自动抢占焦点。沿用现有鼠标和 TV 焦点组件、Material ChoiceChip、下拉年份选择器与 go_router，无新增依赖。

## 检查

```powershell
flutter analyze
flutter test test/bangumi_discovery_repository_test.dart test/bangumi_discovery_view_model_test.dart test/bangumi_discovery_view_test.dart
dart tools/probe_bangumi_discovery.dart
```

`tools/check.ps1 -ProbeLive` 包含新探针。它对一个真实条目检查关联和演员，并验证周历、季度日期范围及榜单；不读取账号私有资料，不执行收藏或评分写入。Widget 测试截图保存在被忽略的 `artifacts/bangumi-discovery-previews`，使用测试字体和固定样例，仅供布局检查，不代表设备真实字体或实时内容。

本次不包含账号同步、人物作品集页面、制作人员页面、评分分布或专题片单；它们可在现有接口层继续扩展。

参考：[官方 v0 OpenAPI](https://github.com/bangumi/api/blob/master/open-api/v0.yaml)、[每日放送定义](https://github.com/bangumi/api/blob/master/open-api/api.yml)。
