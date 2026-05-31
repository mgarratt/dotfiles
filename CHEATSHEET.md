# Cheatsheet

The good stuff this setup gives you, so you stop doing things the slow way.
Covers zsh, fzf, tmux, starship, mise, git, Claude, and the WSL shims. Neovim has its
own: [nvim/CHEATSHEET.md](nvim/CHEATSHEET.md).

tmux prefix is **`C-b`** (default). "In copy-mode" means after `prefix [`.

---

## Shell (zsh)

| What | How |
|---|---|
| **autocd** — cd by typing the dir | `Projects/dotfiles` ⏎ (no `cd`) |
| **vi mode** on the command line | `Esc` for normal mode, then `v` to edit line in `$EDITOR` |
| **Accept autosuggestion** (greyed-out history) | `→` or `End` |
| **extendedglob** | e.g. `^*.txt` (not-txt), `**/*.zsh` (recursive), `*(.)` (files only) |
| Reuse last command's args | `!$` (last arg), `!!` (whole line), `!*` (all args) |

### Aliases & functions

| Alias | Expands to |
|---|---|
| `vim` | `nvim` |
| `fd` | `fdfind` (Ubuntu's binary name) |
| `gst` | `git status` |
| `rfkill` | `sudo rfkill` |
| `cc` / `ccc` / `ccr` | `claude` / `claude --continue` / `claude --resume` |

**`ccwt <branch> [base-ref]`** — make a git worktree at `../<repo>-worktrees/<branch>`
and drop a Claude session into it. Run an agent on a branch without disturbing your
checkout.

---

## fzf

Trigger key for completion is **`~~`** then `Tab` (e.g. `vim ~~<Tab>`, `kill ~~<Tab>`).

| Binding | Does |
|---|---|
| `Ctrl-R` | Fuzzy-search command history |
| `Ctrl-T` | Fuzzy-pick files/dirs into the command line |
| `Alt-C` | Fuzzy-pick a dir and `cd` into it |

**Smart previews** when completing via `~~<Tab>`:
- `cd ~~<Tab>` → `tree` preview of each dir
- `export`/`unset ~~<Tab>` → shows the variable's value
- `ssh ~~<Tab>` → `dig` lookup of the host

> `tree` and `dig` (provisioned by `bootstrap.sh`) power these two previews; the
> history/file/dir pickers work regardless.

File/dir walking uses `fd` (hidden files included, `.git` excluded).

---

## tmux

### Panes & windows
| Binding | Does |
|---|---|
| `prefix %` | Split horizontally, **same dir** |
| `prefix "` | Split vertically, **same dir** |
| `C-h/j/k/l` | Move between panes (no prefix) — and seamlessly into vim/fzf splits |
| `C-\` | Jump to last pane |
| `prefix h` | Set this pane's title (shown in the border) |

Windows number from **1**, renumber on close, and flag activity. The status-bar
window name follows the active pane's title (so a Claude session shows its name,
not just `zsh`). Inactive panes are dimmed.

### Copy mode (`prefix [`, vi keys)
| Binding | Does |
|---|---|
| `v` | Begin selection |
| `y` | Copy selection to system clipboard (tmux-yank) + exit |
| `/` `?` | **Regex** search forward / backward (built-in; replaced tmux-copycat) |
| `n` / `N` | Next / previous match |
| `o` | Open selected path/URL via `xdg-open` (tmux-open) |
| `C-o` | Open selection in `$EDITOR` |
| `S` | Search selection on **DuckDuckGo** (configured) |

tmux-yank also: `prefix y` copies the command line, `prefix Y` copies the cwd.

### Power moves
| Binding | Does |
|---|---|
| `prefix C` | **Pop up an ephemeral Claude session** in the current pane's dir (90% overlay) |
| `prefix Tab` | **extrakto** — fuzzy-grab any path/URL on screen and paste/copy it |

`prefix C` is pop → use → quit: a modal overlay, not a pane, so it can't be minimised
or parked. Quitting Claude closes it. For a session you'll step away from, run `cc` in
a split or use `ccwt`.

---

## starship prompt

- **Timestamp** on the right of every prompt — stays in scrollback, so old commands
  keep their run-time.
- **Kubernetes context + namespace** always shown — a guard against running against
  prod by mistake.
- **direnv** indicator when a dir's env is loaded; **AWS** profile/region shown by default.
- `✳` magenta marker when you're in a shell **Claude Code spawned** (so a subshell
  isn't mistaken for your own).
- Inside Claude, the statusline shows dir, branch, model, a **context-window gauge**
  (green→yellow→orange→red as it fills), session cost and elapsed time.

---

## mise (toolchain)

- Versions switch **automatically per project** from `mise.toml` / `.mise.toml`.
- Also reads other managers' files: `.nvmrc`/`.node-version`, `.ruby-version`/`Gemfile`,
  `.java-version`/`.sdkmanrc`, `.python-version` (node, ruby, java, python).
- `corepack` is on, so `yarn`/`pnpm` shims appear after a node install.
- Global tools: node (lts), ruby, java (temurin-21), clojure, leiningen, go, gh,
  starship, terraform, rust, sops.
- Handy: `mise ls`, `mise current`, `mise use <tool>@<ver>` (project) / `-g` (global),
  `mise doctor`.

---

## git

- `gst` → status. `defaultBranch = main`.
- Identity name is shared; **email lives in `~/.gitconfig.local`** per machine
  (pulled in via `[include]`).

---

## Claude Code

- Aliases `cc` / `ccc` / `ccr`; worktree launcher `ccwt`; tmux popup `prefix C`.
- **Attention notifier**: on finish / needing input it rings the bell, flags the tmux
  window (clears when you switch to it), and fires a desktop notification.

---

## WSL shims (`~/.local/bin`, ahead of `/usr/bin`)

- **`xdg-open`** → routes URLs/files to the Windows host via `wslview` (so `o` in
  tmux copy-mode, and anything calling xdg-open, just works).
- **`notify-send`** → emits a **Windows toast** (used by the Claude notifier);
  skipped when the terminal is already focused.

---

## Secrets

- Edit with `sops zsh/.zsh/secrets.enc.env`; decrypted into the env at shell start.
- Age key is machine-local at `~/.config/sops/age/keys.txt` — never committed.
