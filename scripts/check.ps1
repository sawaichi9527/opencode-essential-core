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
