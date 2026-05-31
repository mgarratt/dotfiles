#!/usr/bin/env bash
# Claude Code attention notifier — wired to the Notification, Stop and
# UserPromptSubmit hooks (see ~/.claude/settings.json).
#
#   Notification / Stop : ring the terminal bell (tmux flags the window and clears
#                         it when you switch there), stash a marker in the window's
#                         @claude_alert option, and fire a desktop notification.
#   UserPromptSubmit    : you're back at the keyboard — clear the marker.
#
# The desktop notification goes through notify-send: on WSL that's the toast shim
# in the wsl stow package (~/.local/bin/notify-send); on a native box it's the
# real libnotify. Everything is guarded and best-effort: a hook must never fail
# a session.

set -uo pipefail

event="$(cat 2>/dev/null)"

# Minimal, dependency-free JSON string lookup (best-effort; toast text only).
json_str() {
    printf '%s' "$event" \
        | grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
        | head -1 | sed 's/.*"\([^"]*\)"[[:space:]]*$/\1/'
}

tmux_alert() {  # $1 = marker, or empty to clear
    [ -n "${TMUX:-}" ] || return 0
    if [ -n "$1" ]; then
        tmux set-window-option -t "${TMUX_PANE:-}" @claude_alert "$1" 2>/dev/null || true
    else
        tmux set-window-option -t "${TMUX_PANE:-}" -u @claude_alert 2>/dev/null || true
    fi
}

name="$(json_str hook_event_name)"

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

# Desktop notification via notify-send (WSL toast shim or native libnotify).
# Hooks can run with a lean PATH, so make sure the shim's dir is on it.
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH" ;; esac
if command -v notify-send >/dev/null 2>&1; then
    body="$(json_str message)"; body="${body:-$title}"
    notify-send "$title" "$body" >/dev/null 2>&1 || true
fi

exit 0
