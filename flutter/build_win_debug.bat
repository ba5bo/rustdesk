@echo off
chcp 65001 >nul
set "PATH=C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;%USERPROFILE%\.cargo\bin;%USERPROFILE%\flutter\bin;%PATH%"
set "VCPKG_ROOT=d:\user\mr\github\utils\rustdesk"
set "VCPKG_INSTALLED_ROOT=d:\user\mr\github\utils\rustdesk\vcpkg_installed"
set "LIBCLANG_PATH=%USERPROFILE%\.local\libclang\clang\native"
set "FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn"
set "PUB_HOSTED_URL=https://pub.flutter-io.cn"
set HTTP_PROXY=
set HTTPS_PROXY=

cd /d d:\user\mr\github\utils\rustdesk\flutter

echo.
echo ============================================
echo Step 1: Clean old build cache
echo ============================================
if exist build\windows rmdir /s /q build\windows
echo Done.

echo.
echo ============================================
echo Step 2: flutter pub get
echo ============================================
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo WARNING: pub get had errors, continuing anyway...
)

echo.
echo ============================================
echo Step 3: flutter build windows --debug
echo ============================================
flutter build windows --debug 2>&1

echo.
echo ============================================
echo Exit code: %ERRORLEVEL%
echo ============================================
if %ERRORLEVEL% EQU 0 (
    echo SUCCESS! Exe at: build\windows\x64\runner\Debug\flutter_hbb.exe
) else (
    echo BUILD FAILED. Check the error messages above.
)
pause
