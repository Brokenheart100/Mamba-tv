# GitHub 自动发布 Android APK

`.github/workflows/release-android.yml` 在推送 `v*` 标签时运行：校验版本与 Secrets → Flutter 静态检查、单元 / Widget 测试和本地协议探针 → 正式签名的 Release 分架构 APK → 验签与 SHA256 → GitHub Release。测试不操作模拟器，也不依赖真实第三方番剧源。

CI 固定 Flutter 3.47.5（Dart 3.13.4）、Temurin JDK 17、Ubuntu 24.04、Android API 36 / Build Tools 36.0.0 / NDK 28.2.13676358。Actions 引用固定提交，依赖使用已提交的 `pubspec.lock`。Release 打包保留默认的 Pub / 平台生成步骤，以排除 `integration_test` 等开发插件，不使用 `--no-pub`；打包后检查锁文件没有改变。升级 Flutter 后需同步核对这些组件。

Android 工具使用现成的 [android-actions/setup-android](https://github.com/android-actions/setup-android) 显式安装，固定 Command-line Tools 16.0（12266719），由该 Action 配置 `ANDROID_HOME` / `ANDROID_SDK_ROOT`、PATH 和 SDK 许可，随后验证 `sdkmanager` 及同一 SDK 目录中的 `apksigner`。不依赖托管 runner 镜像预先提供这些工具或 PATH。

## 一次性配置签名

如果已有该应用的正式密钥，请继续使用，不要重新生成。首次发布可在自己的 PowerShell 中执行以下命令（路径按本机 Android Studio 安装位置调整）：

```powershell
& 'D:\Software\AS\jbr\bin\keytool.exe' -genkeypair -v `
  -keystore "$env:USERPROFILE\mamba-tv-release.jks" `
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias mamba-tv
```

交互填写密钥库密码、证书信息、私钥密码。如果私钥密码提示直接回车，则私钥密码与密钥库密码相同。密钥和密码自行备份；以后更新继续使用这把密钥。正式签名与原有 Debug 签名不同，不能直接覆盖已安装的 Debug 应用；卸载会删除当前收藏和历史。

在仓库 **Settings → Secrets and variables → Actions → Repository secrets → New repository secret** 中添加以下四项（不是 Variables，也不是 Environment secrets）：

| Secret 名称 | 填写内容 |
| --- | --- |
| `ANDROID_KEYSTORE_BASE64` | 整个 `.jks` 文件的 Base64 文本，不是文件路径 |
| `ANDROID_KEYSTORE_PASSWORD` | 创建密钥库时输入的密码，原样填写，不加引号 |
| `ANDROID_KEY_ALIAS` | 密钥别名；使用上面的命令即填 `mamba-tv` |
| `ANDROID_KEY_PASSWORD` | 私钥密码；若创建时直接回车则与密钥库密码相同 |

使用下面的 PowerShell 命令把 Base64 复制到剪贴板，再粘贴到 `ANDROID_KEYSTORE_BASE64` 的 Secret 输入框：

```powershell
[Convert]::ToBase64String(
  [IO.File]::ReadAllBytes("$env:USERPROFILE\mamba-tv-release.jks")
) | Set-Clipboard
```

不要把密钥、Base64 或密码发到聊天、提交到仓库或放进 Release。GitHub 单个 Secret 上限为 48 KB；普通单密钥 JKS 通常远小于此限制。工作流只在打包步骤注入密码，临时还原密钥到 runner 的临时目录，最后清除；缺少签名配置直接失败，不回退到 Debug 签名。

发布使用 GitHub 自动提供的 `GITHUB_TOKEN`，工作流已声明 `contents: write`，**不需要添加 PAT 或名为 GITHUB_TOKEN 的 Secret**。如果组织策略禁止该权限，需要管理员允许工作流写入仓库内容。

## 发布版本

1. 在 `pubspec.yaml` 设置版本，例如 `version: 0.1.0+1`。标签只使用 `v0.1.0`，不带 `+1`。后续更新请递增 `+` 后的 Android 构建号；CI 校验格式和标签一致性，但不会跨历史版本自动校验或递增构建号。
2. 提交本次代码，确保包含工作流、Gradle 签名配置、锁文件及生成代码。首次可显式提交本次配置：

   ```powershell
   git add .github/workflows/release-android.yml android/app/build.gradle.kts README.md docs/releasing.md docs/verification.md
   git commit -m "ci: publish signed Android releases on version tags"
   git push origin HEAD
   git tag -a v0.1.0 -m "Mamba TV v0.1.0"
   git push origin v0.1.0
   ```

   后续修改版本时也要提交 `pubspec.yaml`。标签必须指向包含这份工作流的提交。普通分支推送不会触发发布。
3. 在仓库 **Actions → Release Android APK** 查看执行过程，通过后到 **Releases** 下载：

   - `mamba-tv-v0.1.0-arm64-v8a.apk`：ARM 64 位设备。
   - `mamba-tv-v0.1.0-armeabi-v7a.apk`：ARM 32 位设备。
   - `mamba-tv-v0.1.0-x86_64.apk`：x86_64 设备 / 模拟器。
   - `SHA256SUMS.txt`：APK 文件校验值。

发布会自动生成更新说明。`version: 0.1.0-rc.1+1` 对应 `v0.1.0-rc.1`，包含 `-` 的版本会标为 Pre-release。版本校验、测试、签名或构建任一步失败都不会进入发布步骤；APK 也会保留在 Actions 的构建附件中 14 天。

同一标签运行中的任务会排队，不会互相取消。发布步骤使用 `gh release create --verify-tag`，不覆盖已有 Release；成功发布后不要重用或移动这个标签，修复请用新版本。若上传中断留下草稿，可在 Releases 检查并删除未发布草稿，再重跑失败任务；若已经公开发布则使用新版本。

## 首次运行 sdkmanager 不存在的修复

`v0.1.0` 的首次运行在 SDK 安装步骤报 `sdkmanager: command not found`，发生在编译和密钥恢复之前。原因是工作流没有显式初始化 Android Command-line Tools。修复已接入上面的 setup-android Action，签名 Secrets 不需要因此重新生成。

修复后的版本为 `0.1.1+2`。提交并推送修复后，创建新标签来执行新工作流：

```powershell
git add .github/workflows/release-android.yml pubspec.yaml docs/releasing.md docs/verification.md
git commit -m "ci: initialize Android SDK before release build"
git push origin HEAD
git tag -a v0.1.1 -m "Mamba TV v0.1.1"
git push origin v0.1.1
```

直接对旧运行点击 Re-run jobs 仍会使用原标签提交中的旧工作流，无法取得本次修复。保留 `v0.1.0` 的失败记录，不移动标签。只有新运行通过后，才能确认托管 runner 上的完整发布链路。

## 本机 Release 构建（可选）

CI 无需 `key.properties`。本机可创建被忽略的 `android/key.properties`：

```properties
storeFile=C:\\Users\\123\\mamba-tv-release.jks
storePassword=你的密钥库密码
keyAlias=mamba-tv
keyPassword=你的私钥密码
```

然后执行 `flutter build apk --release --split-per-abi`。也支持环境变量 `ANDROID_KEYSTORE_PATH`、`ANDROID_KEYSTORE_PASSWORD`、`ANDROID_KEY_ALIAS`、`ANDROID_KEY_PASSWORD`，对应值优先于属性文件；Debug 构建不需要这些配置。

参考：[Flutter Android 签名与打包](https://docs.flutter.dev/deployment/android)、[GitHub Secrets](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets)、[GitHub CLI Release](https://cli.github.com/manual/gh_release_create)。
