# Mamba Animation TV

独立的 Flutter Android TV 动漫客户端，参考 [Animeko](https://github.com/open-ani/animeko) 的产品思路。采用 MVVM + Clean Architecture；没有复制 Animeko 源码或品牌素材，也不会修改旁边的 `animeko-web` 项目。

## 当前功能

- Bangumi 真实目录：首页本周放送、高分作品、名称搜索与分页、番剧详情、完整分页章节。
- 新番周历：保留星期分组，按天查看，返回详情后保留所选星期。
- 新番与榜单：季度日期范围、年份、动画形式筛选与分页；详情页提供系列作品跳转、角色和声优。见 [功能说明](docs/bangumi-discovery.md)。
- 动漫分类：地区标签、形式、题材、年份组合筛选，综合排名 / 热度 / 评分排序；支持重置、收起筛选和分页，点击海报进入原有详情。
- Animeko 在线数据源：直接读取相同的 creamycake ani-subs 订阅，支持 web-selector / json-api，复用上游的站点、搜索、线路与视频匹配规则；首次自动获取、手动更新、添加订阅和启停。MacCMS 仅保留为可选扩展。
- Talker：统一应用日志、Bangumi 网络日志、Riverpod 生命周期与关键业务异常；设置中可打开现成的日志查看页。
- 弹弹play自动弹幕：按 Bangumi 明确关联和唯一集数加载，支持滚动 / 顶部 / 底部、暂停 / 缓冲 / 跳转 / 倍速同步及 TV 弹幕设置；歧义候选等待用户确认。
- TV 交互：方向键焦点、确认键选择、焦点边框、聚焦时自动滚动、返回详情前页面。
- 本机追番收藏、观看记录、秒级播放进度、删除单条历史。
- 为每个章节绑定自己的 HTTPS 视频地址；地址只保存在本机 SQLite，不提交到目录服务。
- media_kit 播放：播放/暂停、前后 10 秒、倍速、手动下一集、可选自动下一集、控制面板显隐。
- 每 5 秒、暂停、切集、后台和退出播放时保存进度；未看完续播，接近结束时重新开始。
- 独立播放器测试入口，使用 Flutter 官方示例视频，明确标注且不写入番剧记录。
- Android TV 启动入口、非触摸屏声明、独立图标和 TV banner，最低 Android API 24。

## 启动

本机验证环境：Flutter 3.47.5 / Dart 3.13.4。项目的 SDK 约束、依赖版本见 `pubspec.yaml`，应用应提交 `pubspec.lock`。

```powershell
Set-Location D:\Code\VueProjects\animeko-tv
flutter pub get --enforce-lockfile
flutter run -d <Android设备编号>
```

这台机器的 Flutter 位于 `C:\Users\123\develop\flutter-3.47.5`，Android SDK 位于 `D:\Software\ASSDK`，JDK 位于 `D:\Software\AS\jbr`。如果 Flutter 未加入 PATH，使用完整路径执行 `bin\flutter.bat`。`android/local.properties` 保存本机路径，不提交到版本控制。

使用流程：发现 / 搜索 → 番剧详情 → 章节「选择数据源」→ 搜索作品 → 选择线路和集数 → 核对后解析并播放。也可以在「设置视频地址」中手动填写直链。设置页可打开独立播放器测试。

自动弹幕需要在构建时注入弹弹play凭证，本机通过 `flutter run --dart-define-from-file="$env:USERPROFILE\.config\mamba-tv\dandanplay.json"` 启动；播放器中可打开「弹幕设置」。真实凭证保存在仓库外，Release 从 GitHub Secrets 注入，见 [弹幕说明](docs/danmaku.md)。

需要在 Windows 上直接用鼠标和电脑方向键调试时，使用开发模拟器启动脚本：

```powershell
./tools/start-tv.ps1 -AndroidSdk D:\Software\ASSDK -Restart -LaunchApp
```

脚本在备份 AVD 配置后启用虚拟键盘和鼠标转触控输入，并冷启动、等待 Android 完成启动。`-Restart` 会关闭并重新启动指定 AVD；只影响该模拟器，不清除应用数据。`-LaunchApp` 打开已经安装的应用；首次开发仍需运行 `flutter run`。可通过 `-AvdName` / `-Port` 指定其他 TV 模拟器。

该配置用于开发时方便鼠标操作，真实电视的遥控器及非触屏兼容性仍需单独验收。脚本对当前 Android Emulator 37.2.12 / Android TV API 36 的输入路径进行过 Windows 鼠标键盘实测；不能用 ADB 注入成功代替宿主机输入验证。

从旧版切换到 Riverpod 后，先执行 `flutter pub get --enforce-lockfile`，停止原调试会话并重新运行；本次依赖、根作用域和 ViewModel 基类变更需要完整重启应用。

## 检查与构建

默认数据源沿用 [Animeko README 指向的在线订阅](https://github.com/creamycake-anime/ani-subs)：`https://sub.creamycake.org/v1/css1.json`。首次进入数据源管理 / 选择器会自动获取，已经添加过 MacCMS 的旧安装也会保留旧配置并补入默认订阅。设置 → 数据源管理 →「更新 Animeko 数据源」可刷新规则，「添加订阅」支持其他兼容在线订阅；更新保留启停状态，失败不会覆盖已有配置。当前这份订阅返回 20 个源：19 个网页规则源、1 个 JSON API 源。

搜索默认使用番剧中文名，也可修改关键词；选择作品、线路和源集数，核对目标章节后解析并绑定。网页源使用 `html` / `json_path` 读取上游选择规则，并用 `flutter_inappwebview` 执行播放页和观察视频请求；JSON API 源按订阅中的请求模板、JSONPath 和候选线路获取视频。不会按标题或集数自动绑定整季。支持保留 Referer / User-Agent / Cookie 和明确的源集数绑定，后续播放会重新解析同一个绑定，更新过期直链。

自定义 MacCMS 可通过「添加视频源」继续添加，作为扩展；这与 Animeko 订阅中的网页 / JSON API 规则是不同的数据源类型。

查看日志：设置 → 查看应用日志。使用 `talker_flutter` / `talker_dio_logger` / `talker_riverpod_logger` 5.1.20，同一个 Talker 实例，历史上限 300 条。详细控制台和 Riverpod 日志仅在 Debug 开启，Release 保留有限的应用事件 / 错误历史；历史默认仅在内存，重启不保留。视频源网络日志只记录来源 ID、状态和耗时，不记录接口参数、响应正文或播放 URL；播放进度不逐秒写日志。日志页的导出 / 分享由使用者主动执行。

侧栏「动漫分类」进入 `/categories`。筛选由 Bangumi 服务端执行，地区和形式按社区标签匹配，可能存在标注不全或交叉归类。年份可选当前年到 2000 年，以及「更早」。筛选控件复用 Flutter Material `ChoiceChip`，状态与分页复用现有 Riverpod `CatalogViewModel`，没有新增依赖。

当前 Bangumi 搜索接口没有首字母筛选或按最新日期排序，本页提供接口实际支持的三种排序，不对已加载的一页数据冒充全库筛选。接口契约见 [Bangumi OpenAPI](https://github.com/bangumi/api/blob/master/open-api/v0.yaml)。

```powershell
flutter analyze --no-pub
flutter test test --no-pub
dart run tools/probe_bangumi.dart
dart run tools/probe_maccms.dart
dart tools/probe_animeko_sources.dart
flutter build apk --debug --no-pub
```

Android TV 设备集成测试（需要联网获取 Flutter 官方示例视频）：

```powershell
flutter drive --driver=test_driver/integration_test.dart `
  --target=integration_test/tv_smoke_test.dart -d <AndroidTV设备编号>
```

该测试使用真实 media_kit 引擎验证时间推进、首帧通知、遥控器播放键暂停、控制面板显隐和资源释放，并检查示例视频中央区域的像素，防止黑屏被误判为成功；元数据使用独立测试夹具，不写入正式应用的收藏或历史。截图输出到 `artifacts/screenshots/native-player.png`。

统一检查脚本：

```powershell
./tools/check.ps1 -FlutterSdk C:\Users\123\develop\flutter-3.47.5
./tools/check.ps1 -FlutterSdk C:\Users\123\develop\flutter-3.47.5 `
  -AndroidSdk D:\Software\ASSDK -JavaHome D:\Software\AS\jbr -BuildApk -ProbeLive
```

Debug APK 默认输出到 `build/app/outputs/flutter-apk/app-debug.apk`。脚本的 `-BuildApk` 会额外复制到 `artifacts/mamba-tv-debug.apk`，方便安装。Debug 产物用于开发验证。

GitHub 自动发布已配置：推送与 `pubspec.yaml` 版本一致的 `v*` 标签后，自动检查、使用 Secrets 正式签名、构建三种架构的 Release APK 并发布到 GitHub Releases。首次需要填写四个签名 Secrets，具体步骤见 [发布说明](docs/releasing.md)。Release 缺少密钥会失败，不再使用 Debug 签名。

生成代码已经保存在项目内。变更领域模型、API DTO 或数据库表之后执行：

```powershell
dart run build_runner build
```

## 架构

```text
lib/
  app/                         启动装配、路由、主题
  domain/                      纯 Dart 模型、Repository/Engine 接口、用例
    use_cases/prepare_playback  读取本集媒体、恢复观看位置
  data/
    services/                  Bangumi、Animeko 订阅 / 规则、WebView 解析、MacCMS 扩展
    repositories/              目录、本地资料库、设置、数据源配置实现
    database/                  Drift 表与生成代码
    playback/                  media_kit 适配器
  presentation/
    core/                      焦点组件、海报、通用页面片段
    features/                  发现、分类、搜索、详情、资料库、播放、数据源、设置
```

状态管理和依赖注入统一使用 `flutter_riverpod`。View 通过 `ref.watch` 监听不可变状态，通过 `ref.read(provider.notifier)` 执行 ViewModel 命令；所有业务 ViewModel 继承 `Notifier`。页面级状态自动释放，资料库流保留到应用作用域结束。`app/dependencies.dart` 创建具体实现，`app/providers.dart` 暴露领域接口，根 `ProviderScope` 注入依赖，测试使用 overrides 替换仓库和引擎。

Repository 接口、实体和播放用例留在纯 Dart Domain 层；Data 实现接口。`FocusNode`、动画、滚动、文本输入控制器和视频渲染留在 Widget 中。具体说明见 [架构说明](docs/architecture.md)。

## 边界

- Bangumi 是元数据服务，不提供这些番剧的视频。首页海报与简介不表示已有可播放资源。
- 默认在线站点来自 Animeko 使用的远程订阅；站点失效、验证页、网页改版或上游规则变更会影响可用性，需要更新订阅或换源。网页源的 Android WebView 解析已接入，但本轮按用户要求未操作设备，不能声称每个网页站点实播均通过。JSON API 源已经验证真实搜索、线路、取址及 MP4 字节读取，仍不等同于目标电视解码验收。
- 当前只接入在线 `web-selector` / `json-api` 订阅。BT / RSS 需要独立下载 / libtorrent 引擎，尚未接入；不把磁力或 torrent 当作普通视频 URL 播放。
- 登录、云同步、下载、BT、DRM 和音轨/字幕轨选择界面尚未实现。弹幕已接入弹弹play公开读取接口，不包含发送弹幕或用户账号功能。
- 手动地址入口仍要求 HTTPS 直链；Animeko 订阅的 HTTP / HTTPS 站点和请求头按规则处理。带用户名密码的 URL、本地文件 URI 暂不支持。源与线路由用户明确选择，解码兼容性依赖设备。
- 观看记录、收藏和地址属于当前安装。清除应用数据 / 卸载会删除这些数据；尚无导入导出。SQLite 内的媒体 URL 不是加密保险箱，请避免在地址中放置长期账号凭证。
- 模拟器验证与真实电视硬件验证分别记录；4K、HDR、ASS 字幕和各厂商硬解兼容性尚不能由模拟器结果推断。
- 已为 Android 模拟器加入 MediaCodec Surface 输出兼容路径，物理设备保留默认渲染；模拟器路径不支持 GL 滤镜和 ASS 合成。具体原因见架构说明。

验证记录见 [verification.md](docs/verification.md)。

## 后续阶段

1. 在目标电视验证 Animeko 各网页源的 WebView 取址、站点会话与真实解码，再扩展 BT / RSS；保留番剧与资源的明确匹配边界。
2. 音轨 / 字幕轨选择、外置字幕、播放器焦点与沉浸式体验深化。
3. 弹幕屏蔽词、密度与更多来源扩展；继续独立于播放引擎。
4. 按实际授权协议实现账号和追番同步。
5. 普通文件 / HLS 离线缓存，再评估原生 libtorrent 边下边播。

接口参考：[Bangumi OpenAPI](https://github.com/bangumi/api/blob/master/open-api/v0.yaml)、[Flutter 架构](https://docs.flutter.dev/app-architecture/guide)、[Flutter Focus](https://docs.flutter.dev/ui/interactivity/focus)、[media_kit](https://pub.dev/packages/media_kit)、[Android TV](https://developer.android.com/training/tv/get-started/create)。
