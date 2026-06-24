$cmakeDir = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
$ninjaDir = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja"
$env:PATH = "$cmakeDir;$ninjaDir;$env:USERPROFILE\.cargo\bin;$env:USERPROFILE\.local\nasm\nasm-2.16.03;$env:USERPROFILE\flutter\bin;$env:PATH"
$env:VCPKG_ROOT = "d:\user\mr\github\utils\rustdesk"
$env:VCPKG_INSTALLED_ROOT = "d:\user\mr\github\utils\rustdesk\vcpkg_installed"
$env:LIBCLANG_PATH = "$env:USERPROFILE\.local\libclang\clang\native"
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"
$env:HTTP_PROXY = "http://10.33.250.177:8888"
$env:HTTPS_PROXY = "http://10.33.250.177:8888"

Set-Location "d:\user\mr\github\utils\rustdesk"

Write-Host "=== Running flutter_rust_bridge_codegen ==="
flutter_rust_bridge_codegen --rust-input ./src/flutter_ffi.rs --dart-output ./flutter/lib/generated_bridge.dart 2>&1
