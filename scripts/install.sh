#!/bin/bash
# Install the visual-first-design skills into ~/.agents/skills/ for engines
# that read the cross-runtime skills directory (Codex, Gemini CLI, Copilot CLI).
# Copies are DOWNSTREAM of this repo: refresh by re-running this script; never edit the copies.
set -euo pipefail

SRC="$(cd "$(dirname "$0")/.." && pwd)/skills"
DEST="$HOME/.agents/skills"
STAMP="$(date +%Y-%m-%d)"

mkdir -p "$DEST"
for dir in "$SRC"/*/; do
  name="$(basename "$dir")"
  mkdir -p "$DEST/$name"
  cp "$dir/SKILL.md" "$DEST/$name/SKILL.md"
  # Provenance note after frontmatter (line 1 must stay '---')
  awk -v stamp="$STAMP" 'NR==1{print; next} !done && /^---$/{print; print "<!-- DOWNSTREAM COPY of visual-first-design/skills/'"$name"'/SKILL.md (github.com/Stevekaplanai/visual-first-design). Copied " stamp ". Refresh from source; do not edit here. -->"; done=1; next} {print}' \
    "$DEST/$name/SKILL.md" > "$DEST/$name/SKILL.md.tmp" && mv "$DEST/$name/SKILL.md.tmp" "$DEST/$name/SKILL.md"
  echo "installed: $DEST/$name/SKILL.md"
done
echo "Done. Engines reading ~/.agents/skills will pick these up next session."
