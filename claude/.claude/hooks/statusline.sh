#!/usr/bin/env bash
# Claude Code status line entry point.
#
# Delegates to statusline.py (the width-aware assembler) when python3 is
# available; otherwise falls back to the combined `claude-code` Starship profile
# — degraded (no rate limits / no width-fitting) but always something.
#
# Claude Code sets $COLUMNS/$LINES before running us (v2.1.153+); statusline.py
# reads $COLUMNS to fit the line and break to two rows on narrow terminals.

set -uo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
input="$(cat)"

if command -v python3 >/dev/null 2>&1 && [ -f "$dir/statusline.py" ]; then
    printf '%s' "$input" | COLUMNS="${COLUMNS:-}" python3 "$dir/statusline.py"
else
    printf '%s' "$input" | starship statusline claude-code 2>/dev/null
fi
