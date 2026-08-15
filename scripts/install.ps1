# Install the visual-first-design skills into ~/.agents/skills/ for engines
# that read the cross-runtime skills directory (Codex, Gemini CLI, Copilot CLI).
# Copies are DOWNSTREAM of this repo: refresh by re-running this script; never edit the copies.
$ErrorActionPreference = "Stop"

$src = Join-Path (Split-Path $PSScriptRoot -Parent) "skills"
$dest = Join-Path $env:USERPROFILE ".agents\skills"
$stamp = Get-Date -Format "yyyy-MM-dd"

New-Item -ItemType Directory -Force $dest | Out-Null
Get-ChildItem $src -Directory | ForEach-Object {
    $name = $_.Name
    $target = Join-Path $dest $name
    New-Item -ItemType Directory -Force $target | Out-Null
    $lines = Get-Content (Join-Path $_.FullName "SKILL.md")
    $out = New-Object System.Collections.Generic.List[string]
    $inserted = $false
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $out.Add($lines[$i])
        if (-not $inserted -and $i -gt 0 -and $lines[$i] -eq "---") {
            $out.Add("<!-- DOWNSTREAM COPY of visual-first-design/skills/$name/SKILL.md (github.com/Stevekaplanai/visual-first-design). Copied $stamp. Refresh from source; do not edit here. -->")
            $inserted = $true
        }
    }
    # WriteAllLines writes BOM-less UTF-8; PS 5.1's Out-File -Encoding utf8 adds a BOM that breaks YAML frontmatter parsers
    [System.IO.File]::WriteAllLines((Join-Path $target "SKILL.md"), $out)
    Write-Host "installed: $(Join-Path $target 'SKILL.md')"
}
Write-Host "Done. Engines reading ~/.agents/skills will pick these up next session."
