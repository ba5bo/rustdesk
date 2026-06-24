$ErrorActionPreference = "Continue"
$env:PATH = "C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;$env:USERPROFILE\.cargo\bin;$env:PATH"
$env:VCPKG_ROOT = "d:\user\mr\github\utils\rustdesk"
$env:VCPKG_INSTALLED_ROOT = "d:\user\mr\github\utils\rustdesk\vcpkg_installed"
$env:LIBCLANG_PATH = "$env:USERPROFILE\.local\libclang\clang\native"
Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue
Set-Location d:\user\mr\github\utils\rustdesk
Write-Output "============================================"
Write-Output "Building librustdesk.dll with --features flutter"
Write-Output "============================================"
cargo build --lib --features flutter 2>&1
$exitCode = $LASTEXITCODE
Write-Output "============================================"
Write-Output "Exit code: $exitCode"
Write-Output "============================================"
if ($exitCode -eq 0) {
    Copy-Item "target\debug\librustdesk.dll" "flutter\build\windows\x64\runner\Debug\librustdesk.dll" -Force
    Write-Output "SUCCESS! DLL copied to flutter output directory."
}
else {
    Write-Output "BUILD FAILED."
}
