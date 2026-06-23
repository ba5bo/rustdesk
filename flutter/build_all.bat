@echo off
chcp 65001 >nul
echo ===== RustDesk Flutter 编译修复脚本 =====
echo.

echo 步骤 1: 删除旧的 Flutter 工具缓存（强制重建）
del /f /q "%USERPROFILE%\flutter\bin\cache\flutter_tools.snapshot" 2>nul
if exist "%USERPROFILE%\flutter\bin\cache\flutter_tools.snapshot" (
  echo !!! 无法删除缓存文件，请以管理员身份运行此脚本 !!!
  pause
  exit /b 1
)
echo 已删除.

echo 步骤 2: 应用 VS 2026 兼容补丁到 Flutter SDK
powershell -ExecutionPolicy Bypass -File "%~dp0\patch_vs.ps1"
echo.

echo 步骤 3: 运行 Flutter doctor 验证（会自动重建缓存）
call "%USERPROFILE%\flutter\bin\flutter.bat" doctor
echo.
echo Flutter doctor 完成.

echo.
echo 步骤 4: 清理旧的构建目录
if exist "%~dp0build\windows" (
  rmdir /s /q "%~dp0build\windows"
  echo 已清理旧构建目录.
) else (
  echo 无需清理.
)

echo.
echo 步骤 5: 运行 Flutter Windows Debug 编译
set PATH=%USERPROFILE%\flutter\bin;%PATH%
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
set PUB_HOSTED_URL=https://pub.dartlang.org
cd /d "%~dp0"
echo 正在编译，请耐心等待...
echo.
call flutter build windows --debug
echo.
echo ===== 编译退出代码: %ERRORLEVEL% =====
pause
