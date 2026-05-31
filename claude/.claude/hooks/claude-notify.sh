#!/usr/bin/env bash
# Claude Code attention notifier — wired to the Notification, Stop and
# UserPromptSubmit hooks (see ~/.claude/settings.json).
#
#   Notification / Stop : ring the terminal bell — tmux shows a bell flag on the
#                         window and clears it when you switch there, so across
#                         several sessions you can see which one wants you — stash
#                         a marker in the window's @claude_alert option (for a
#                         custom status format), and fire a best-effort Windows
#                         toast on WSL.
#   UserPromptSubmit    : you're back at the keyboard — clear the marker.
#
# Everything is guarded and best-effort: a hook must never fail a session.

set -uo pipefail

event="$(cat 2>/dev/null)"

# Minimal, dependency-free JSON string lookup (best-effort; toast text only).
json_str() {
    printf '%s' "$event" \
        | grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
        | head -1 | sed 's/.*"\([^"]*\)"[[:space:]]*$/\1/'
}

name="$(json_str hook_event_name)"

tmux_alert() {  # $1 = marker, or empty to clear
    [ -n "${TMUX:-}" ] || return 0
    if [ -n "$1" ]; then
        tmux set-window-option -t "${TMUX_PANE:-}" @claude_alert "$1" 2>/dev/null || true
    else
        tmux set-window-option -t "${TMUX_PANE:-}" -u @claude_alert 2>/dev/null || true
    fi
}

case "$name" in
    UserPromptSubmit)
        tmux_alert ""
        exit 0
        ;;
    Stop)         marker="✅"; title="Claude finished" ;;
    Notification) marker="🔔"; title="Claude needs you" ;;
    *)            marker="🔔"; title="Claude" ;;
esac

# Bell: audible + tmux window bell flag (auto-clears when you focus the window).
{ printf '\a' > /dev/tty; } 2>/dev/null || printf '\a' 2>/dev/null || true

tmux_alert "$marker"

# Best-effort Windows toast via BurntToast, if the module is installed. Run
# detached so a slow PowerShell start never holds up the session.
if command -v powershell.exe >/dev/null 2>&1; then
    body="$(json_str message)"; body="${body:-$title}"
    # Strip quotes/backticks so the text can't break out of the PS string.
    body="${body//\'/}"; body="${body//\`/}"; title="${title//\'/}"
    (
        powershell.exe -NoProfile -NonInteractive -Command \
            "if (Get-Module -ListAvailable -Name BurntToast) { Import-Module BurntToast; New-BurntToastNotification -Text '$title', '$body' }" \
            >/dev/null 2>&1
    ) &
fi

exit 0
