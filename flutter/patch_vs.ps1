$file = "C:\Users\mr\flutter\packages\flutter_tools\lib\src\windows\visual_studio.dart"
$content = [IO.File]::ReadAllText($file)

# Fix 1: cmakeGenerator - add VS 2026 (v18) support  
# Match: "      17 => 'Visual Studio 17 2022',\n      _  => 'Visual Studio 16 2019',"
$pattern1 = "(?s)(17 => 'Visual Studio 17 2022',\r?\n\s+_  => 'Visual Studio 16 2019',)"
$replacement1 = "17 => 'Visual Studio 17 2022',`r`n      18 => 'Visual Studio 18 2026',`r`n      _  => 'Visual Studio 16 2019',"
$content = [regex]::Replace($content, $pattern1, $replacement1)

# Fix 2: version range [16,18) to skip VS 2026
# Match: "      _vswhereMinVersionArgument,\n      _minimumSupportedVersion.toString(),"
$pattern2 = "(?s)(_vswhereMinVersionArgument,\r?\n\s+)_minimumSupportedVersion\.toString\(\),"
$replacement2 = "`${1}'[16,18)',"
$content = [regex]::Replace($content, $pattern2, $replacement2)

[IO.File]::WriteAllText($file, $content)
Write-Host "Patches applied successfully"
