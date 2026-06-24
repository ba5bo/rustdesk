$env:PATH = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;$env:USERPROFILE\.cargo\bin;$env:USERPROFILE\.local\nasm\nasm-2.16.03;$env:USERPROFILE\flutter\bin;$env:PATH"
$env:VCPKG_ROOT = "d:\user\mr\github\utils\rustdesk"
$env:VCPKG_INSTALLED_ROOT = "d:\user\mr\github\utils\rustdesk\vcpkg_installed"
$env:LIBCLANG_PATH = "$env:USERPROFILE\.local\libclang\clang\native"
Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue

Set-Location "d:\user\mr\github\utils\rustdesk"

Write-Host "=== Running flutter_rust_bridge_codegen ==="
flutter_rust_bridge_codegen --rust-input ./src/flutter_ffi.rs --dart-output ./flutter/lib/generated_bridge.dart --llvm-path "$env:USERPROFILE\.local\libclang\clang" 2>&1
Write-Host "=== Done, exit code: $LASTEXITCODE ==="
Read-Host "Press Enter to exit"
