[CmdletBinding()]
param(
    [string]$TargetDir = (Join-Path $HOME ".config\opencode\skills"),
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$SourceDir = Join-Path $RepoRoot "skills"

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

Write-Host "Done. Restart OpenCode before validation."
