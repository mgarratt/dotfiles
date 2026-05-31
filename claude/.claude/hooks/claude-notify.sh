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

tmux_alert() {  # $1 = marker, or empty to clear
    [ -n "${TMUX:-}" ] || return 0
    if [ -n "$1" ]; then
        tmux set-window-option -t "${TMUX_PANE:-}" @claude_alert "$1" 2>/dev/null || true
    else
        tmux set-window-option -t "${TMUX_PANE:-}" -u @claude_alert 2>/dev/null || true
    fi
}

# Best-effort Windows toast (WSL), via the built-in Windows.UI.Notifications API
# (no module to install). Two refinements:
#   • Attributed to the host terminal's AppUserModelID (Windows Terminal when
#     $WT_SESSION is set), so the toast reads "Terminal" and clicking it
#     activates the terminal rather than PowerShell.
#   • Suppressed when that terminal is already the foreground window — no point
#     toasting the session you're looking at.
# PowerShell is base64-encoded to dodge quoting, and run detached.
win_toast() {  # $1 = title, $2 = body
    command -v powershell.exe >/dev/null 2>&1 || return 0
    command -v iconv >/dev/null 2>&1 && command -v base64 >/dev/null 2>&1 || return 0
    local title="$1" body="$2"
    title="${title//\'/}"; title="${title//\`/}"   # neutralise PS string breakers
    body="${body//\'/}";   body="${body//\`/}"

    local appid skip
    if [ -n "${WT_SESSION:-}" ]; then
        appid='Microsoft.WindowsTerminal_8wekyb3d8bbwe!App'   # click -> focus Terminal
        skip='WindowsTerminal'                                 # don't toast when focused
    else
        appid='{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
        skip=''
    fi

    local ps enc
ps="$(cat <<PS
\$ErrorActionPreference='SilentlyContinue'
try {
  \$skip='${skip}'
  if (\$skip) {
    Add-Type -Name FG -Namespace W -MemberDefinition '[DllImport("user32.dll")] public static extern System.IntPtr GetForegroundWindow(); [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(System.IntPtr h, out uint p);'
    \$pid2=0; [void][W.FG]::GetWindowThreadProcessId([W.FG]::GetForegroundWindow(), [ref]\$pid2)
    if ((Get-Process -Id \$pid2 -ErrorAction SilentlyContinue).ProcessName -eq \$skip) { exit }
  }
  [Windows.UI.Notifications.ToastNotificationManager,Windows.UI.Notifications,ContentType=WindowsRuntime] | Out-Null
  \$tpl=[Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
  \$txt=\$tpl.GetElementsByTagName('text')
  \$txt.Item(0).AppendChild(\$tpl.CreateTextNode('${title}')) | Out-Null
  \$txt.Item(1).AppendChild(\$tpl.CreateTextNode('${body}')) | Out-Null
  # Notification-only: a body click dismisses instead of launching a new window.
  \$root=\$tpl.SelectSingleNode('/toast')
  \$root.SetAttribute('activationType','background') | Out-Null
  \$root.SetAttribute('launch','') | Out-Null
  \$toast=[Windows.UI.Notifications.ToastNotification]::new(\$tpl)
  [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('${appid}').Show(\$toast)
} catch {}
PS
)"
    enc="$(printf '%s' "$ps" | iconv -f UTF-8 -t UTF-16LE 2>/dev/null | base64 -w0 2>/dev/null)" || return 0
    [ -n "$enc" ] || return 0
    ( powershell.exe -NoProfile -NonInteractive -EncodedCommand "$enc" >/dev/null 2>&1 & )
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

body="$(json_str message)"; body="${body:-$title}"
win_toast "$title" "$body"

exit 0
