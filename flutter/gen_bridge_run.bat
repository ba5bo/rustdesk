@echo off
set "PATH=C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;%USERPROFILE%\.cargo\bin;%USERPROFILE%\.local\nasm\nasm-2.16.03;%USERPROFILE%\flutter\bin;%PATH%"
set "VCPKG_ROOT=d:\user\mr\github\utils\rustdesk"
set "VCPKG_INSTALLED_ROOT=d:\user\mr\github\utils\rustdesk\vcpkg_installed"
set "LIBCLANG_PATH=%USERPROFILE%\.local\libclang\clang\native"
REM Remove proxy
set HTTP_PROXY=
set HTTPS_PROXY=
cd /d d:\user\mr\github\utils\rustdesk

echo === Running flutter_rust_bridge_codegen ===
flutter_rust_bridge_codegen --rust-input ./src/flutter_ffi.rs --dart-output ./flutter/lib/generated_bridge.dart
echo === Done, exit code: %ERRORLEVEL% ===
pause
