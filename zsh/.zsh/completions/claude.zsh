#!/bin/zsh
# Claude Code shell ergonomics. Guarded by has() so it no-ops when claude is
# absent (same pattern as the other files sourced from completions/).
has claude || return

alias cc='claude'
alias ccc='claude --continue'
alias ccr='claude --resume'

# ccwt <branch> [base-ref]: create a git worktree for <branch> and open Claude
# in it — for running an agent on a branch without disturbing your checkout.
# Worktrees live in ../<repo>-worktrees/<branch> beside the repo.
ccwt() {
    emulate -L zsh
    local branch="$1"
    [[ -n "$branch" ]] || { print -u2 "usage: ccwt <branch> [base-ref]"; return 1 }
    local root
    root="$(git rev-parse --show-toplevel 2>/dev/null)" \
        || { print -u2 "ccwt: not inside a git repository"; return 1 }
    local dir="${root}-worktrees/${branch//\//-}"
    if [[ ! -d "$dir" ]]; then
        git -C "$root" worktree add -B "$branch" "$dir" "${2:-HEAD}" || return
    fi
    ( cd "$dir" && claude )
}
