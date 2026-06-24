@echo off
chcp 65001 >nul
set "PATH=C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;%USERPROFILE%\.cargo\bin;%PATH%"
set "VCPKG_ROOT=d:\user\mr\github\utils\rustdesk"
set "VCPKG_INSTALLED_ROOT=d:\user\mr\github\utils\rustdesk\vcpkg_installed"
set "LIBCLANG_PATH=%USERPROFILE%\.local\libclang\clang\native"
cd /d d:\user\mr\github\utils\rustdesk
echo ============================================
echo Building librustdesk.dll with --features flutter
echo ============================================
cargo build --lib --features flutter 2>&1
echo ============================================
echo Exit code: %ERRORLEVEL%
echo ============================================
if %ERRORLEVEL% EQU 0 (
    echo SUCCESS! DLL built.
    copy /y target\debug\librustdesk.dll flutter\build\windows\x64\runner\Debug\librustdesk.dll
    echo Copied DLL to flutter output directory.
)
pause
