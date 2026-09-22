# Detect the OpenCode major version that will consume these components.
# Returns the major version as a string (e.g. "2"), or $null when undetectable.
#
# Lets install / check treat OpenCode v1.x.x and v2.x.x differently. Some
# components (workspace-layout, instructions) are only meaningful on v1; on v2
# the AGENTS.md mechanism replaces them.

function Get-OpenCodeMajorVersion {
    [OutputType([string])]
    param()

    $major = $null

    # 1. opencode on PATH
    $cmd = Get-Command opencode -ErrorAction SilentlyContinue
    if ($cmd) {
        try {
            $out = & $cmd.FullName --version 2>$null
            if ($out -match 'opencode v(\d+)\.\d+\.\d+') {
                $major = $Matches[1]
            }
        }
        catch { }
    }

    # 2. Desktop-bundled CLI, e.g. %USERPROFILE%\.config\ai.opencode.desktop\cli\2.0.12\
    if (-not $major) {
        $cliBase = Join-Path $HOME '.config\ai.opencode.desktop\cli'
        if (Test-Path $cliBase) {
            $dirs = Get-ChildItem -Path $cliBase -Directory -ErrorAction SilentlyContinue
            foreach ($dir in $dirs) {
                if ($dir.Name -match '^(\d+)\.\d+\.\d+') {
                    $major = $Matches[1]
                    break
                }
            }
        }
    }

    return $major
}
