# MVVM + Clean Architecture

## 依赖边界

- Domain：纯 Dart，不导入 Flutter、Dio、Drift、Riverpod 或 media_kit。Freezed 只用于不可变值模型。
- Data：实现 Domain 定义的接口，将 Bangumi DTO 转成实体，将 Dio 异常转成领域失败信息。
- Presentation：所有 ViewModel 使用 Riverpod `Notifier<State>`，State 为包含不可变列表的 Dart record；View 使用 ConsumerWidget / ConsumerStatefulWidget 监听状态并执行命令。播放页面在外层使用 media_kit 的 Video Widget，领域播放接口不暴露 VideoController。
- App：`dependencies.dart` 创建数据库、HTTP 客户端、仓库和引擎工厂；`providers.dart` 暴露领域接口；根 ProviderScope 通过 overrideWithValue 注入具体实现。路由只传递番剧编号与播放会话参数，不创建业务 ViewModel。

简单查询由 ViewModel 调用仓库。跨媒体源与历史记录的续播规则放在 PreparePlayback 用例中，避免为每个仓库方法编写无业务含义的转发用例。

## 数据模型

- Anime / Episode：领域元数据，不包含第三方播放地址。
- AnimeFilter：沿用 Freezed 的不可变查询模型；地区、形式、题材、年份、排序，由 Data 层翻译为 Bangumi 请求条件。
- WatchProgress：章节级播放位置、时长、最后保存时间与展示资料快照。
- PlayableMedia：已选媒体 URI 与引擎所需 Headers；当前自定义地址功能不提供 Headers 输入。
- MediaSourceBinding：用户确认的源 ID、源集数 ID / 播放页与线路上下文。重新播放按同一个绑定取址，避免缓存签名 URL 过期后重新按名字猜测作品。
- PlaybackSnapshot：引擎播放状态的不可变值对象。
- AppFailure：领域层可展示失败，不让页面依赖 DioException。

本地 Drift 数据库 `mamba_tv`，schemaVersion = 2：

| 表 | 主键 | 内容 |
| --- | --- | --- |
| favorites | subjectId | 番剧资料快照、收藏时间 |
| watch_records | episodeId | 番剧 / 章节资料、毫秒位置与时长、更新时间 |
| media_bindings | episodeId | 用户确认的视频 URI、请求头 JSON、可选源集数绑定 JSON |

设置使用 SharedPreferencesAsync。后续新增表字段必须提供迁移，不能通过清库掩盖 schema 变更。

v1 → v2 通过 Drift MigrationStrategy 添加 `headers_json`（默认 `{}`）与可空 `source_binding_json`；保留旧的媒体地址、收藏和历史。迁移有真实 SQLite 内存数据库测试，文件数据库关闭 / 重开测试同时验证请求头和源绑定恢复。

## 页面与资源生命周期

首页、分类与搜索有独立的 autoDispose provider，互不覆盖，共用 CatalogViewModel。分类和搜索复用同一个 Repository 搜索方法，分类条件作为可选的 AnimeFilter 传入。CatalogViewModel 用递增请求序号忽略旧搜索或分页结果；切换条件清空结果并从 offset 0 查询，后续分页保留完整条件。分页 offset 按服务器返回行数推进，卡片按 ID 去重，空页停止继续加载；失败保留已有卡片并支持原条件重试。异步回调发布状态前检查 `ref.mounted`，释放后不再更新 UI。

详情使用按番剧编号区分的 family provider；设置在页面退出后释放，再进入时从仓库读取。LibraryViewModel 的 provider 保留在应用作用域内，订阅数据库流，收藏和历史变更自动刷新；`ref.onDispose` 取消订阅。

每个播放路由创建独立 PlaybackEngine。ViewModel 每五秒、暂停、切集、后台与退出时保存进度，按顺序执行数据库写入。切换下一集时先保存当前集再切换实体；没有绑定视频的下一集等待用户输入。播放器测试不进入历史保存路径。

播放页面负责 Wakelock、应用生命周期和视频 Widget，退出等待保存并释放引擎。当前没有后台音频播放服务。隐藏控制面板后保留可通过确认键激活的「显示控制」入口。

PlaybackViewModel 由 autoDispose family 管理，参数包含番剧编号、章节编号、测试标记和 GoRouter 的页面 key。同一集的不同路由各自持有引擎，同一路由重建保留会话。显式返回先等待 `close()` 保存进度和关闭引擎；移除最后一个监听者也通过 `ref.onDispose` 触发同一个幂等关闭任务，防止原生资源泄漏。Wakelock 通过 `ref.listen` 跟随播放状态变化。

这些页面同时有分页、保存、缺少视频源和原生播放事件等状态，统一用 `Notifier` 发布完整状态快照，异步操作在命令内完成。无需引入旧式 ChangeNotifierProvider 或 StateNotifierProvider。参考 [Riverpod 迁移指南](https://riverpod.dev/docs/migration/from_change_notifier) 与 [自动释放说明](https://riverpod.dev/docs/concepts2/auto_dispose)。

单元测试通过 ProviderContainer 和领域 provider overrides 运行，用 listen 保持 autoDispose provider 存活；取消监听后检查实际释放、播放进度保存和引擎关闭。Widget 测试沿用生产 ProviderScope 与路由，仅替换依赖。

Android 模拟器通过 `device_info_plus` 识别，仅模拟器采用 `mediacodec_embed` / `mediacodec` 输出，绕过新系统镜像的 EGL 黑屏问题；物理设备保留 media_kit 默认输出。该模拟器路径不覆盖 GL 滤镜、ASS 合成和播放器截图 API，不能用于这些能力的实机验收。配置参照 [上游 issue 的复现与解决方案](https://github.com/media-kit/media-kit/issues/1343) 和 [mpv 输出文档](https://mpv.io/manual/stable/)。

## TV 组件

TvFocus 使用 FocusableActionDetector、Shortcuts 和 Actions 实现选择；方向移动沿用 Flutter 原生焦点遍历，焦点变化时 RenderObject.showOnScreen 请求视口以最小距离显示目标，避免强制居中导致标题滚出屏幕。焦点节点由 Widget 管理，路由 push/pop 保留前页焦点范围。

布局按窗口约束决定完整或紧凑侧栏；菜单本身可滚动，避免小窗口高度溢出。列表与网格使用 builder / SliverGrid。

分类页使用 Material ChoiceChip 的选择状态、语义和键盘激活行为，沿用 Flutter 方向焦点遍历，仅在获得焦点时请求视口显示该筛选项，并通过 WidgetState 配置可见的焦点边框。已选摘要、重置和折叠控制与筛选面板一起滚动，海报沿用 AnimeCard / TvFocus。收起面板方便电视上浏览结果，进入详情再返回保留当前条件、面板状态和滚动位置。

## 视频数据源与日志

Domain 新增 SourceRepository、VideoSource、SourceTitle、SourcePage、SourceLine / SourceEpisode。视频源的资源编号与 Bangumi 番剧 / 章节编号完全分开。MacCmsService 按官方 Provide 契约请求 `ac=list&wd=...&pg=...` 和 `ac=detail&ids=...`，解析 `vod_play_from` / `vod_play_url` 的线路与集数分隔符；兼容过滤后返回的逗号线路名称。接口专属 query 保留，API 操作参数由客户端覆盖。

PreferencesSourceRepository 将配置序列化到 SharedPreferencesAsync 的 `video_sources_v1`，串行写入避免丢失并发编辑。默认读取 Animeko 使用的 `https://sub.creamycake.org/v1/css1.json`，兼容 schemaVersion 2 和旧 exportedMediaSourceDataList 包装，保留 `factoryId` / `arguments` 原始规则。升级旧安装也只补入一次默认订阅，不删除已有 MacCMS 配置。更新按稳定源 ID 合并、保留启停状态，仅移除同一订阅已下线的源；校验失败不覆盖旧配置。

AnimekoSourceService 使用 Dart 官方 html 的 CSS Selector、json_path 的标准 JSONPath 和 Dio 的 HTTP 客户端读取 `web-selector` 与 `json-api` 规则。网页格式支持 a / indexed / json-path-indexed、index-grouped / no-channel；JSON API 支持配置化 URL / HTTP 方法 / JSON 请求模板 / Headers、条目与线路 / 集数选择器、指定线路的视频候选选择。请求间隔和 CookieJar 沿用订阅配置及现成库。

WebVideoResolver 直接使用 flutter_inappwebview 的 HeadlessInAppWebView，执行站点原播放器脚本，观察网络资源和 video / source URL，按订阅 matchVideo 的正则与命名捕获匹配；不把嵌套解析页当视频直链。保留规则里的 Referer / User-Agent 及站点 Cookie。超时和取消进入 finally 释放 WebView。用户离开源选择页会取消解析。此原生路径已经构建、尚未在本轮设备上验收；遇到验证码 / 站点变更会提示换源，不自动绕过验证。

SourcePickerViewModel 只查询启用的数据源，用递增序号忽略过期搜索、分页和线路响应，释放后不发布状态。选择器明确显示目标番剧 / 章节与源作品 / 线路 / 集数，确认后解析并调用 LibraryRepository.bindMedia 绑定当前章节，同时保留 MediaSourceBinding。RefreshMediaBinding 在后续播放前按同一个源与集数更新临时地址和请求头，不重新猜测或匹配作品；PreparePlayback 仍负责续播位置。MacCMS 仅为兼容扩展，不作为 Animeko 数据源的替代。

Talker 实例在 main 创建，经 AppDependencies 和 talkerProvider 共享；框架和未处理异步异常、关键业务失败、Bangumi Dio 请求以及 Riverpod 观察器都写入同一历史。日志页直接使用 TalkerScreen。300 条内存历史限制用于控制占用；Debug 开启控制台与 Riverpod 生命周期记录，Provider 状态只输出类型，排除高频播放状态。源接口使用 Dio InterceptorsWrapper 记录状态与耗时，避免将私有接口 query、播放 URL 或视频源响应对象写入日志历史。业务异常保留类型与堆栈，省略可能包含媒体地址的第三方异常消息。

协议依据：[Animeko 数据源说明](https://github.com/open-ani/animeko/blob/main/docs/contributing/code/media/media-source.md)、[ani-subs](https://github.com/creamycake-anime/ani-subs)、[SelectorSearchConfig](https://github.com/open-ani/animeko/blob/main/app/shared/app-data/src/commonMain/kotlin/domain/mediasource/web/SelectorSearchConfig.kt)。MacCMS 扩展依据 [官方 API 文档](https://github.com/magicblack/maccms10/wiki/%E5%85%A5%E5%BA%93%E6%8E%A5%E5%8F%A3%E8%AF%B4%E6%98%8E)。日志和 WebView API 按已锁定版本的包源码核实，未增加自定义日志 / 浏览器框架。

## 扩展接口

后续可实现其他 SourceRepository 适配器与解析器。不要让 BangumiRepository 返回推测的视频 URL，也不要将某番剧第一集的地址套用到全部章节。

播放引擎可替换为 Kotlin Media3 适配器。字幕轨、音轨、下载和账号同步应分别增加领域接口和具体实现；电视硬解、平台合成与解码格式需通过目标设备样片验证。

## Bangumi 发现扩展

Domain 的 `BangumiDiscoveryRepository` 与 Freezed 不可变模型独立于 Flutter / Dio。`RemoteBangumiDiscoveryRepository` 负责星期归组、去重、关系动画类型过滤及角色 / 内嵌演员映射；与原目录仓库共享 Bangumi HTTP 客户端。`CalendarViewModel`、`BrowseViewModel`、`SubjectExtrasViewModel` 均采用 Riverpod Notifier，视图不直接请求服务。

周历切天仅选择已加载的分组；季度查询通过完整日期范围复用搜索，综合榜单使用浏览接口的 rank 排序。分页按原始响应数量推进 offset，显示列表按 ID 去重；筛选代次隔离旧响应，失败保留现有结果供重试。系列作品与角色的加载状态分别维护，局部失败不阻断原详情或选集操作。UI 复用 AnimeCard、图片缓存、TV 焦点和 Material 筛选控件，不新增第三方依赖。具体接口与边界见 [bangumi-discovery.md](bangumi-discovery.md)。

## 自动弹幕

Domain 的 `DanmakuRepository`、不可变模型和时间游标独立于 Flutter / Dio。Data 的 `DandanplayService` 负责官方鉴权、HTTPS 加速跳转与有界内存缓存，`DandanplayRepository` 负责 Bangumi 明确关联 / 唯一集数匹配、候选与本机选择 / 设置持久化。纯标题搜索只提供候选，不能自动确定季度。

App 根作用域注入弹幕仓库。PlaybackViewModel 通过 Riverpod 发布独立的弹幕加载状态，利用取消信号及代次隔离异步响应，不改变视频错误状态；示例会话跳过弹幕。Presentation 的 `DanmakuOverlay` 根据视频时间调度并驱动 `canvas_danmaku` 控制器，绘制 / 轨道 / 防碰撞复用依赖。暂停、缓冲、跳转、倍速和时间偏移由状态同步，不在 Domain 保存 BuildContext / Flutter 控制器。

配置与验证方式见 [danmaku.md](danmaku.md)。
