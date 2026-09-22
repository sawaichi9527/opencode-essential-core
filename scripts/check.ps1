[CmdletBinding()]
param(
    [string]$TargetDir = (Join-Path $HOME ".config\opencode\skills"),
    [string]$CommandTargetDir = ""
)

$RepoRoot = Split-Path -Parent $PSScriptRoot

# This pack targets OpenCode v2 only: verify the plural commands/ directory.
# An explicit -CommandTargetDir override always wins.
$CommandTargetDir = if ($CommandTargetDir) { $CommandTargetDir } else { Join-Path $HOME ".config\opencode\commands" }

$Expected = @(
    "environment-check",
    "config-check",
    "project-init",
    "session-start",
    "session-close",
    "git-basic",
    "workspace-layout",
    "teamwork-update-check"
)

$Failed = $false
foreach ($Name in $Expected) {
    $SkillFile = Join-Path (Join-Path $TargetDir $Name) "SKILL.md"
    if (Test-Path $SkillFile) {
        Write-Host "[OK] $Name"
    } else {
        Write-Host "[MISSING] $Name"
        $Failed = $true
    }
}

$CommandFiles = @(
    "teamwork-update-check.md",
    "project-init.md",
    "environment-check.md",
    "config-check.md",
    "session-start.md",
    "session-close.md"
)

$commandDirLabel = [System.IO.Path]::GetFileName($CommandTargetDir.TrimEnd('/','\'))
foreach ($CommandName in $CommandFiles) {
    $CommandFile = Join-Path $CommandTargetDir $CommandName
    if (Test-Path $CommandFile) {
        Write-Host "[OK] $commandDirLabel/$CommandName"
    } else {
        Write-Host "[MISSING] $commandDirLabel/$CommandName"
        $Failed = $true
    }
}

$ProjectInitReferences = @(
    "AGENTS.template.md",
    "handoff.template.md"
)
$ReferenceDir = Join-Path (Join-Path $TargetDir "project-init") "references"
foreach ($Reference in $ProjectInitReferences) {
    $ReferencePath = Join-Path $ReferenceDir $Reference
    if (Test-Path $ReferencePath) {
        Write-Host "[OK] project-init/references/$Reference"
    } else {
        Write-Host "[MISSING] project-init/references/$Reference"
        $Failed = $true
    }
}

if ($Failed) { exit 1 }
Write-Host "Essential Core validation passed."
