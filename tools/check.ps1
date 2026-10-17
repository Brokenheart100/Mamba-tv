param(
  [string]$FlutterSdk,
  [string]$AndroidSdk,
  [string]$JavaHome,
  [switch]$BuildApk,
  [switch]$ProbeLive
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
if ($FlutterSdk) {
  $flutterExe = Join-Path $FlutterSdk 'bin/flutter.bat'
  $dartExe = Join-Path $FlutterSdk 'bin/dart.bat'
} else {
  $flutterExe = (Get-Command flutter -ErrorAction Stop).Source
  $dartExe = Join-Path (Split-Path $flutterExe -Parent) 'dart.bat'
}
if ($AndroidSdk) { $env:ANDROID_HOME = $AndroidSdk }
if ($JavaHome) { $env:JAVA_HOME = $JavaHome }
function Invoke-Flutter([string[]]$Arguments) {
  & $flutterExe @Arguments
  if ($LASTEXITCODE -ne 0) { throw "Flutter command failed: $($Arguments -join ' ')" }
}
Push-Location $projectRoot
try {
  Invoke-Flutter @('pub', 'get', '--enforce-lockfile')
  Invoke-Flutter @('analyze', '--no-pub')
  Invoke-Flutter @('test', 'test', '--no-pub')
  & $dartExe run tools/probe_maccms.dart
  if ($LASTEXITCODE -ne 0) { throw 'MacCMS local protocol check failed' }
  if ($ProbeLive) {
    & $dartExe run tools/probe_bangumi.dart
    if ($LASTEXITCODE -ne 0) { throw 'Bangumi live probe failed' }
    & $dartExe tools/probe_animeko_sources.dart
    if ($LASTEXITCODE -ne 0) { throw 'Animeko subscription/source live probe failed' }
  }
  if ($BuildApk) {
    Invoke-Flutter @('build', 'apk', '--debug', '--no-pub')
    $artifactDir = Join-Path $projectRoot 'artifacts'
    New-Item -ItemType Directory -Path $artifactDir -Force | Out-Null
    $apk = Join-Path $artifactDir 'mamba-tv-debug.apk'
    Copy-Item -LiteralPath (Join-Path $projectRoot 'build/app/outputs/flutter-apk/app-debug.apk') -Destination $apk -Force
    $apkInfo = Get-Item -LiteralPath $apk
    $apkHash = Get-FileHash -LiteralPath $apk -Algorithm SHA256
    [ordered]@{ File=$apkInfo.FullName; SizeBytes=$apkInfo.Length; SHA256=$apkHash.Hash } |
      ConvertTo-Json | Set-Content -LiteralPath (Join-Path $artifactDir 'build-info.json') -Encoding utf8
    $apkHash
  }
} finally { Pop-Location }
