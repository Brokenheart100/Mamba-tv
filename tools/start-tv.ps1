param(
  [string]$AndroidSdk = $env:ANDROID_HOME,
  [string]$AvdName = 'Mamba_TV_API36',
  [ValidateRange(5554, 5682)][int]$Port = 5554,
  [switch]$Restart,
  [switch]$LaunchApp
)
$ErrorActionPreference = 'Stop'
if (!$AndroidSdk) { $AndroidSdk = $env:ANDROID_SDK_ROOT }
if (!$AndroidSdk) { throw 'Pass -AndroidSdk or set ANDROID_HOME.' }
if ($Port % 2) { throw 'The emulator console port must be even.' }
if ($AvdName -notmatch '^[A-Za-z0-9_.-]+$') { throw 'Invalid AVD name.' }
$emulatorExe = Join-Path $AndroidSdk 'emulator/emulator.exe'
$adbExe = Join-Path $AndroidSdk 'platform-tools/adb.exe'
if (!(Test-Path -LiteralPath $emulatorExe) -or !(Test-Path -LiteralPath $adbExe)) {
  throw 'Android SDK emulator or adb executable is missing.'
}
$avdRoot = $env:ANDROID_AVD_HOME
if (!$avdRoot) {
  $androidUserRoot = $env:ANDROID_USER_HOME
  if (!$androidUserRoot) { $androidUserRoot = Join-Path $env:USERPROFILE '.android' }
  $avdRoot = Join-Path $androidUserRoot 'avd'
}
$avdIni = Join-Path $avdRoot "$AvdName.ini"
$pathLine = Get-Content -LiteralPath $avdIni | Where-Object { $_ -match '^path=' } | Select-Object -First 1
if (!$pathLine) { throw "No absolute AVD path found in $avdIni" }
$avdPath = $pathLine.Substring(5)
if (![IO.Path]::IsPathRooted($avdPath)) { throw 'The AVD path must be absolute.' }
$configPath = Join-Path $avdPath 'config.ini'
if (!(Test-Path -LiteralPath $configPath)) { throw "Missing AVD config: $configPath" }
$serial = "emulator-$Port"
$avdPattern = '(?:^|\s)-avd\s+' + [regex]::Escape($AvdName) + '(?:\s|$)'
function Get-TargetProcesses {
  @(Get-CimInstance Win32_Process | Where-Object {
    $_.Name -match '^(emulator|qemu-system-.*)\.exe$' -and $_.CommandLine -match $avdPattern
  })
}
$running = Get-TargetProcesses
if ($running.Count) {
  if (!$Restart) { throw 'This AVD is running. Close it or pass -Restart to apply input settings.' }
  $actualAvd = @(& $adbExe -s $serial emu avd name)
  if ($LASTEXITCODE -ne 0 -or $actualAvd -notcontains $AvdName) {
    throw "Cannot verify that $serial belongs to $AvdName; close the emulator manually."
  }
  & $adbExe -s $serial emu kill
  if ($LASTEXITCODE -ne 0) { throw 'Failed to request emulator shutdown.' }
  $stopDeadline = (Get-Date).AddSeconds(40)
  do { Start-Sleep -Seconds 1; $running = Get-TargetProcesses } while ($running.Count -and (Get-Date) -lt $stopDeadline)
  if ($running.Count) { throw 'The emulator is still closing; retry after it exits.' }
}

$projectRoot = Split-Path $PSScriptRoot -Parent
$artifactDir = Join-Path $projectRoot 'artifacts'
New-Item -ItemType Directory -Path $artifactDir -Force | Out-Null
$configText = [IO.File]::ReadAllText($configPath)
$changedText = $configText
foreach ($setting in @(@('hw.keyboard', 'yes'), @('hw.screen', 'multi-touch'))) {
  $keyPattern = '(?m)^' + [regex]::Escape($setting[0]) + '\s*=.*$'
  $replacement = $setting[0] + '=' + $setting[1]
  if ($changedText -match $keyPattern) {
    $changedText = [regex]::Replace($changedText, $keyPattern, $replacement)
  } else { $changedText += "`r`n$replacement`r`n" }
}
if ($changedText -ne $configText) {
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss-fff'
  Copy-Item -LiteralPath $configPath -Destination (Join-Path $artifactDir "$AvdName-input-before-$stamp.ini")
  [IO.File]::WriteAllText($configPath, $changedText)
}

# This development AVD exposes a virtual keyboard and maps host mouse clicks to
# touch. Keep production TV capability declarations and app input code intact.
$emulatorArgs = @('-avd', $AvdName, '-port', "$Port", '-gpu', 'host', '-no-snapshot',
  '-feature', '-VirtioMouse', '-feature', '-VirtioTablet')
Start-Process -FilePath $emulatorExe -ArgumentList $emulatorArgs -WindowStyle Normal `
  -RedirectStandardOutput (Join-Path $artifactDir "$AvdName-start.log") `
  -RedirectStandardError (Join-Path $artifactDir "$AvdName-start-error.log") | Out-Null
$bootDeadline = (Get-Date).AddMinutes(3)
do {
  Start-Sleep -Seconds 2
  $boot = & $adbExe -s $serial shell getprop sys.boot_completed 2>$null
  if ($LASTEXITCODE -eq 0 -and $boot -eq '1') { break }
  if (!(Get-TargetProcesses).Count) { throw 'Emulator exited; inspect the startup logs in artifacts.' }
} while ((Get-Date) -lt $bootDeadline)
if ($boot -ne '1') { throw 'Android has not completed booting within three minutes.' }
Write-Output "Ready: $serial ($AvdName), keyboard and mouse-to-touch enabled."
if ($LaunchApp) {
  & $adbExe -s $serial shell am start -n app.mamba.mamba_tv/.MainActivity
  if ($LASTEXITCODE -ne 0) { throw 'App launch failed. Install or run the Flutter project first.' }
}
