[CmdletBinding()]
param(
    [string]$TargetDir = (Join-Path $HOME ".config\opencode\skills"),
    [string]$CommandTargetDir = "",
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$SourceDir = Join-Path $RepoRoot "skills"
$CommandSourceDir = Join-Path $RepoRoot "commands"

# This pack targets OpenCode v2 only: commands install to the plural
# commands/ directory; an explicit -CommandTargetDir override always wins.
$CommandTargetDir = if ($CommandTargetDir) { $CommandTargetDir } else { Join-Path $HOME ".config\opencode\commands" }

if (-not (Test-Path $SourceDir)) {
    throw "Skills source directory not found: $SourceDir"
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
Get-ChildItem -Path $SourceDir -Directory | ForEach-Object {
    $name = $_.Name
    $Destination = Join-Path $TargetDir $name
    if ((Test-Path $Destination) -and -not $Force) {
        Write-Warning "Skip existing skill: $name. Use -Force to replace it."
        return
    }
    if (Test-Path $Destination) {
        Remove-Item -Recurse -Force $Destination
    }
    Copy-Item -Recurse -Force $_.FullName $Destination
    Write-Host "Installed: $name"
}

if (Test-Path $CommandSourceDir) {
    New-Item -ItemType Directory -Force -Path $CommandTargetDir | Out-Null
    Get-ChildItem -Path $CommandSourceDir -File -Filter "*.md" | ForEach-Object {
        $name = $_.Name
        $Destination = Join-Path $CommandTargetDir $name
        if ((Test-Path $Destination) -and -not $Force) {
            Write-Warning "Skip existing command: $name. Use -Force to replace it."
            return
        }
        Copy-Item -Force $_.FullName $Destination
        Write-Host "Installed command: $name"
    }
}

Write-Host "Done. Restart OpenCode before validation."
