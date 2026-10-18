# Dart / Flutter 官方 Codex 插件

按 [Flutter 官方 Codex 安装步骤](https://docs.flutter.dev/ai/get-started)执行：

```powershell
codex plugin marketplace add flutter/agent-plugins
codex plugin add dart-flutter@dart-flutter
codex plugin list
```

2026-10-18 的本机验证结果：

- `dart-flutter@dart-flutter` 版本 1.0.6，状态 `installed, enabled`。
- 插件自带官方 Flutter Skills，以及 `dart mcp-server` 配置，不需要再注册一个重复的 Dart MCP 服务。
- 已将当前 Flutter SDK 的 bin 目录加入本机用户 PATH，原用户 PATH 值保存在本机 Codex 数据目录；没有把 SDK 绝对路径写入仓库配置。
- 独立进程完成 MCP initialize / tools/list 握手，服务名 `dart and flutter tooling`，服务版本 1.2.1，返回 14 个工具，包含 `analyze_files`、`get_runtime_errors`、`hot_reload`、`lsp` 和 `pub_dev_search`。
- MCP 握手验证未连接应用、模拟器或电视，也未执行热重载。运行时工具需要后续连接实际的调试应用才能使用。
- 重启 Codex 后，当前会话已实际加载 Dart MCP 工具，`dart` / `flutter` 命令解析到同一套 Flutter SDK。通过 MCP `roots` 添加本项目成功，再使用 `analyze_files` 对整个项目进行只读分析，返回 `No errors`。
- 本轮确认了插件启用、MCP 通信与项目分析。热重载、运行时错误和 Widget 检查需要连接实际调试应用，尚未执行；没有操作模拟器。

官网说明 Codex 插件不会自动加载规则，因此将插件附带的官方 `flutter-hot-reload.md` 原文复制到 `.agent/rules/`，并在 `AGENTS.md` 引用。既有 Riverpod / MVVM / Clean Architecture 和用户对设备操作的限制优先。
