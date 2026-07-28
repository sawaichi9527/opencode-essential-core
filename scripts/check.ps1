[CmdletBinding()]
param(
    [string]$TargetDir = (Join-Path $HOME ".config\opencode\skills")
)

$Expected = @(
    "environment-check",
    "config-check",
    "project-init",
    "session-start",
    "session-close",
    "git-basic"
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

if ($Failed) { exit 1 }
Write-Host "Essential Core validation passed."
