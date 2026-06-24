$ErrorActionPreference = "Continue"

# Kill any existing build processes
Get-Process -Name "flutter", "dart", "dart.exe" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep 2

# Set environment
$env:PATH = "C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;$env:USERPROFILE\.cargo\bin;$env:USERPROFILE\flutter\bin;$env:PATH"
$env:VCPKG_ROOT = "d:\user\mr\github\utils\rustdesk"
$env:VCPKG_INSTALLED_ROOT = "d:\user\mr\github\utils\rustdesk\vcpkg_installed"
$env:LIBCLANG_PATH = "$env:USERPROFILE\.local\libclang\clang\native"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue

Set-Location d:\user\mr\github\utils\rustdesk\flutter

Write-Output "============================================"
Write-Output "Step 1: Clean old build cache"
Write-Output "============================================"
Remove-Item -Recurse -Force build\windows -ErrorAction SilentlyContinue
Write-Output "Done."

Write-Output "`n============================================"
Write-Output "Step 2: flutter pub get"
Write-Output "============================================"
flutter pub get
Write-Output "pub get exit code: $LASTEXITCODE"

Write-Output "`n============================================"
Write-Output "Step 3: flutter build windows --debug (using source to pick up VS 2026 patch)"
Write-Output "============================================"

# Use dart directly with source file to bypass pre-compiled snapshot
$flutterRoot = "$env:USERPROFILE\flutter"
$flutterToolsDir = "$flutterRoot\packages\flutter_tools"
$dart = "$flutterRoot\bin\cache\dart-sdk\bin\dart.exe"
$packageConfig = "$flutterToolsDir\.dart_tool\package_config.json"

# Delete stale snapshot so Flutter's auto-recompile kicks in on next normal run
Remove-Item -Force "$flutterRoot\bin\cache\flutter_tools.snapshot" -ErrorAction SilentlyContinue
Remove-Item -Force "$flutterRoot\bin\cache\flutter_tools.stamp" -ErrorAction SilentlyContinue

# MUST set FLUTTER_ROOT so Cache.defaultFlutterRoot() finds the correct root
$env:FLUTTER_ROOT = $flutterRoot

& $dart --packages=$packageConfig $flutterToolsDir\lib\executable.dart build windows --debug 2>&1
$buildExit = $LASTEXITCODE
Write-Output "`n============================================"
Write-Output "Build exit code: $buildExit"
Write-Output "============================================"
if ($buildExit -eq 0) {
    Write-Output "SUCCESS! Exe at: build\windows\x64\runner\Debug\flutter_hbb.exe"
} else {
    Write-Output "BUILD FAILED."
}
Read-Host "Press Enter to exit"
