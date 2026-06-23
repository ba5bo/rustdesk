$file = "C:\Users\mr\flutter\packages\flutter_tools\lib\src\windows\visual_studio.dart"
$lines = [System.Collections.ArrayList][IO.File]::ReadAllLines($file)
Write-Output "Total lines: $($lines.Count)"

# --- Fix 1: Add v18 mapping to cmakeGenerator ---
$fix1 = $false
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "^\s+17 => 'Visual Studio 17 2022',$" -and ($i+1) -lt $lines.Count -and $lines[$i+1] -match "^\s+_ => 'Visual Studio 16 2019',$") {
        $m = [regex]::Match($lines[$i], "^(\s+)")
        $indent = $m.Groups[1].Value
        $newLine = $indent + "18 => 'Visual Studio 17 2022',"
        $lines.Insert($i+1, $newLine)
        Write-Output "Fix 1 applied: inserted '$newLine'"
        $fix1 = $true
        break
    }
}
if (-not $fix1) {
    Write-Output "Fix 1: already applied or pattern not found"
}

# --- Fix 2: Limit vswhere version range to [16,18) ---
$fix2 = $false
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "^\s+_minimumSupportedVersion\.toString\(\),$") {
        $m = [regex]::Match($lines[$i], "^(\s+)")
        $indent = $m.Groups[1].Value
        $lines[$i] = "$indent'[16,18)',"
        Write-Output "Fix 2 applied: vswhere version range [16,18)"
        $fix2 = $true
        break
    }
}
if (-not $fix2) {
    Write-Output "Fix 2: already applied or pattern not found"
}

[IO.File]::WriteAllLines($file, $lines.ToArray())
Write-Output "Patch complete. Total lines: $($lines.Count)"
