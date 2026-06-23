$cmakeDir = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin"
$ninjaDir = "C:\Program Files\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja"
$env:PATH = "$cmakeDir;$ninjaDir;$env:USERPROFILE\.cargo\bin;$env:USERPROFILE\.local\nasm\nasm-2.16.03;$env:PATH"
$env:VCPKG_ROOT = "$env:USERPROFILE\vcpkg"
Remove-Item Env:\VCPKG_FORCE_SYSTEM_BINARIES -ErrorAction SilentlyContinue
$env:HTTP_PROXY = "http://10.33.250.177:8888"
$env:HTTPS_PROXY = "http://10.33.250.177:8888"
Set-Location "d:\user\mr\github\utils\rustdesk"
& "$env:VCPKG_ROOT\vcpkg.exe" install --triplet x64-windows-static 2>&1
