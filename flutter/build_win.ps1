$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL = "https://pub.dartlang.org"
Remove-Item Env:\HTTP_PROXY -ErrorAction SilentlyContinue
Remove-Item Env:\HTTPS_PROXY -ErrorAction SilentlyContinue

Set-Location "d:\user\mr\github\utils\rustdesk\flutter"
Write-Output "Starting Flutter Windows Debug build..."
flutter build windows --debug 2>&1
Write-Output "Build exit code: $LASTEXITCODE"
