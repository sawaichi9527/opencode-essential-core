[CmdletBinding()]
param(
    [string]$TargetDir = (Join-Path $HOME ".config\opencode\skills"),
    [string]$CommandTargetDir = (Join-Path $HOME ".config\opencode\command"),
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$SourceDir = Join-Path $RepoRoot "skills"
$CommandSourceDir = Join-Path $RepoRoot "command"

if (-not (Test-Path $SourceDir)) {
    throw "Skills source directory not found: $SourceDir"
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
Get-ChildItem -Path $SourceDir -Directory | ForEach-Object {
    $Destination = Join-Path $TargetDir $_.Name
    if ((Test-Path $Destination) -and -not $Force) {
        Write-Warning "Skip existing skill: $($_.Name). Use -Force to replace it."
        return
    }
    if (Test-Path $Destination) {
        Remove-Item -Recurse -Force $Destination
    }
    Copy-Item -Recurse -Force $_.FullName $Destination
    Write-Host "Installed: $($_.Name)"
}

if (Test-Path $CommandSourceDir) {
    New-Item -ItemType Directory -Force -Path $CommandTargetDir | Out-Null
    Get-ChildItem -Path $CommandSourceDir -File -Filter "*.md" | ForEach-Object {
        $Destination = Join-Path $CommandTargetDir $_.Name
        if ((Test-Path $Destination) -and -not $Force) {
            Write-Warning "Skip existing command: $($_.Name). Use -Force to replace it."
            return
        }
        Copy-Item -Force $_.FullName $Destination
        Write-Host "Installed command: $($_.Name)"
    }
}

Write-Host "Done. Restart OpenCode before validation."
