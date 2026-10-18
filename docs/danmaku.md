# 弹弹play 自动弹幕

视频正常打开后，播放器独立加载弹幕，失败不阻断视频播放。默认开启，示例播放器不请求弹幕；自动下一集会取消旧请求并加载新集，旧响应不能覆盖当前集。

## 匹配与显示

1. 使用官方 `GET /api/v2/bangumi/bgmtv/{bgmtvSubjectId}` 获取当前 Bangumi 条目的明确关联。
2. 只为正常整数章节自动选择唯一相同 `episodeNumber` 的弹幕库。不把 Bangumi 章节 ID 当作弹弹play ID，也不通过 ID 取模猜测集数。
3. 多季重复编号、SP、小数集数不盲选。没有关联时调用 `GET /api/v2/search/episodes` 获取候选，只供用户确认，不自动按模糊标题选择。
4. 用户确认的选择按当前 Bangumi 条目 / 章节保存，下次直接加载；「重新匹配」忽略旧绑定并重新获取匹配结果。当前候选列表最多显示 100 项。
5. 使用 `GET /api/v2/comment/{episodeId}?withRelated=true&chConvert=1` 获取关联弹幕。支持滚动、顶部和底部；跳过无效数据、去重并按毫秒时间排序。

播放器 →「弹幕设置」提供开关、字号、透明度、区域、提前 / 延后时间与候选确认。设置保存到本机 Preferences。

渲染复用 `canvas_danmaku 0.3.3`，没有重写轨道与碰撞引擎。自有时间游标只负责根据播放进度投递，暂停 / 缓冲时暂停动画，跳转时清空并定位到当前时间，倍速改变投递节奏和动画时长。显示层不拦截视频按钮的鼠标和遥控器操作。

## 凭证与构建

代码只读取 `DANDANPLAY_APP_ID` / `DANDANPLAY_APP_SECRET` 的 Dart 编译参数，没有真实凭证常量。请求按官方公式生成 `X-AppId`、`X-Timestamp`、`X-Signature`；签名路径不包含查询参数，不发送 `X-AppSecret`。

弹幕接口会 302 跳转到加速服务，客户端只跟随 HTTPS，后续请求不携带应用鉴权头。成功响应在内存中缓存 4 小时、最多 12 个请求结果；应用重启后缓存失效。Talker 仅保留数量、状态和耗时，不打印密钥、签名、响应正文或弹幕内容。

设备时间错误可能导致 `403 / Invalid Timestamp`。仅当原始 HTTPS API 明确返回该错误且提供有效 `Date` 时，客户端按服务器时间重新签名，最多重试一次；后续签名使用服务器时间与单调计时器，不修改系统时间。CDN 响应、无效日期、其他鉴权错误不会触发校时。仍失败时提示开启系统自动日期和时间；应用凭证 / 签名错误会分别提示，不回显原始响应头。

本机配置保存在用户目录的 `.config/mamba-tv/dandanplay.json`（受限访问，位于仓库外），字段示例：

```json
{
  "DANDANPLAY_APP_ID": "YOUR_APP_ID",
  "DANDANPLAY_APP_SECRET": "YOUR_APP_SECRET"
}
```

本机启动：

```powershell
flutter run --dart-define-from-file="$env:USERPROFILE\.config\mamba-tv\dandanplay.json"
```

`tools/check.ps1 -BuildApk` 在本机配置存在时自动使用它，也可通过 `-DanmakuConfig` 指定其他位置。没有凭证的包仍可播放视频，会提示未配置弹幕服务。

GitHub Release 工作流增加同名的两个 **Repository secrets**，构建时临时生成编译配置文件并在结束后删除；缺少配置会在检查步骤失败。它们与 Android APK 签名密钥是两套独立的凭证。

构建注入防止密钥进入 Git 历史，不意味着密钥无法从 APK 中提取。若需要完全不向客户端分发 AppSecret，应在自己的后端签名并转发 API；当前采用官方文档给出的开源客户端构建注入方案。

## 验证方式

```powershell
flutter test test/danmaku_repository_test.dart test/danmaku_playback_test.dart test/danmaku_overlay_test.dart test/danmaku_panel_test.dart
dart tools/probe_dandanplay.dart
dart tools/probe_dandanplay.dart --clock-skew-test
```

探针默认读取上述本机配置，只按一个真实条目 / 集数验证签名、元数据、加速跳转和弹幕解析，不发送弹幕、不批量下载，也不输出鉴权信息。

`--clock-skew-test` 将签名时钟模拟为慢 22 小时，要求真实接口先返回一次时间戳错误，再自动恢复并取得弹幕。它不修改电脑或模拟器时间。

真实电视上的弹幕密集场景、画面合成与长时间播放仍需设备验收；单元 / Widget 测试和 APK 构建不能代替这部分。

参考：[弹弹play接入指南](https://doc.dandanplay.com/open/)、[官方 OpenAPI](https://api.dandanplay.net/swagger/index.html)、[canvas_danmaku](https://pub.dev/packages/canvas_danmaku)。
