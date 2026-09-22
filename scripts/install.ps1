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

# Components that are only meaningful on OpenCode v1.x.x. On v2 the built-in
# AGENTS.md mechanism replaces them, so we skip installing them.
$OptionalOnV2 = @("workspace-layout", "instructions")

. (Join-Path $PSScriptRoot "opencode-version.ps1")
$OpenCodeMajor = Get-OpenCodeMajorVersion
if ($OpenCodeMajor -and ([int]$OpenCodeMajor) -ge 2) {
    $V2Mode = $true
}
else {
    $V2Mode = $false
}

function Test-OptionalOnV2 {
    param([string]$Name)
    return ($OptionalOnV2 -contains $Name)
}

if (-not (Test-Path $SourceDir)) {
    throw "Skills source directory not found: $SourceDir"
}

New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
Get-ChildItem -Path $SourceDir -Directory | ForEach-Object {
    $name = $_.Name
    if ($V2Mode -and (Test-OptionalOnV2 $name)) {
        Write-Host "SKIP: $name is v1-only; ignored on OpenCode v$OpenCodeMajor."
        return
    }
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
        $baseName = $name -replace '\.md$', ''
        if ($V2Mode -and (Test-OptionalOnV2 $baseName)) {
            Write-Host "SKIP: command/$name is v1-only; ignored on OpenCode v$OpenCodeMajor."
            return
        }
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
