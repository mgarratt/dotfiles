#!/usr/bin/env bash
# Claude Code status line. Receives session JSON on stdin; prints a single line.
set -euo pipefail

input=$(cat)
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
: "${cwd:=$PWD}"

dir=$(basename "$cwd")
branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || true)

out="📁 ${dir}"
[[ -n "$branch" ]] && out+="  ⎇ ${branch}"
[[ -n "$model" ]] && out+="  🤖 ${model}"
printf '%s' "$out"
