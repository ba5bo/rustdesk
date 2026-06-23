@echo off
echo ===== RustDesk Flutter Windows Debug Build =====
echo.

echo [1/3] Setting environment variables...
set PATH=%USERPROFILE%\flutter\bin;%PATH%
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
set PUB_HOSTED_URL=https://pub.dartlang.org

echo [2/3] Enabling Developer Mode for symlink support...
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowAllTrustedApps" /d "1" >nul 2>&1
echo Developer Mode enabled.

echo [3/3] Building Flutter Windows Debug...
cd /d "d:\user\mr\github\utils\rustdesk\flutter"
flutter build windows --debug
echo.
echo Build exit code: %ERRORLEVEL%
pause
