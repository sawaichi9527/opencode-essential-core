[CmdletBinding()]
param(
    [string]$TargetDir = (Join-Path $HOME ".config\opencode\skills"),
    [string]$CommandTargetDir = ""
)

$RepoRoot = Split-Path -Parent $PSScriptRoot

. (Join-Path $PSScriptRoot "opencode-version.ps1")
$OpenCodeMajor = Get-OpenCodeMajorVersion
if ($OpenCodeMajor -and ([int]$OpenCodeMajor) -ge 2) {
    $V2Mode = $true
}
else {
    $V2Mode = $false
}

# On OpenCode v2 verify the modern plural commands/ directory; on v1 keep the
# legacy singular command/ directory. An explicit -CommandTargetDir override always wins.
if ($V2Mode) {
    $commandDirName = "commands"
}
else {
    $commandDirName = "command"
}
$CommandTargetDir = if ($CommandTargetDir) { $CommandTargetDir } else { Join-Path $HOME ".config\opencode\$commandDirName" }

# workspace-layout is v1-only: on OpenCode v2 the built-in AGENTS.md mechanism
# replaces it, so it is not expected to be installed.
$Expected = @(
    "environment-check",
    "config-check",
    "project-init",
    "session-start",
    "session-close",
    "git-basic",
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

if ($V2Mode) {
    # instructions is v1-only; skip it on v2.
    $CommandFiles = @("teamwork-update-check.md")
}
else {
    $CommandFiles = @(
        "teamwork-update-check.md",
        "instructions.md"
    )
}

# Label for display: reflects the actual directory used (commands/ on v2, command/ on v1).
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
