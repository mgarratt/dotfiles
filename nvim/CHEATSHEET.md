# Neovim cheatsheet

The good stuff this config gives you. Companion to the root [CHEATSHEET](../CHEATSHEET.md)
(shell/tmux/etc.).

Leader is **`\`**, localleader is **`,`** (Clojure/Conjure). Mappings below are written
out literally, so `\f` means *backslash then f*.

---

## House deviations (the non-obvious bits)

- **Format on save** is automatic (ruff for Python, prettier for web/markdown/yaml). No
  keystroke — just `:w`. Falls back to the LSP formatter if no tool is configured.
- **Lint on save/read** surfaces diagnostics from shellcheck (sh) and ruff (Python),
  on top of LSP diagnostics.
- **Folds open on load** and are treesitter-based — standard `za`/`zR`/`zM` apply.
- **hardtime nags** you when you mash `j`/`k`/arrows or repeat a motion — it's training
  wheels, not a bug. `:Hardtime toggle` to silence it for a session.
- **No Python/Ruby/Node host providers** — nothing here needs them; `:checkhealth`
  flagging them as disabled is expected.

---

## Find & jump (fzf-lua)

| What | How |
|---|---|
| Open a file | `\f` |
| Grep the project (ripgrep) | `\a` |
| Search lines in this buffer | `\/` |
| Switch buffer | `\b` |
| Search `:` commands | `\:` |
| Anything else | `:FzfLua <Tab>` (pickers for marks, registers, help, keymaps…) |

---

## Code intelligence (LSP)

Servers (auto-installed via mason): **pyright**, **ruby-lsp**, **typescript-language-server**,
**terraform-ls**, **lua-language-server**. They attach on file open.

| What | How |
|---|---|
| Go to definition | `gd` |
| Find references | `gr` |
| Hover docs | `K` |
| Rename symbol | `\rn` |
| Code action | `\ca` |
| Document symbols (replaces old tag jump) | `\t` |
| Prev / next diagnostic | `[d` / `]d` |

**Completion** (nvim-cmp) while typing:

| What | How |
|---|---|
| Trigger menu | `C-Space` |
| Next / prev item | `Tab` / `S-Tab` |
| Confirm | `CR` (only if an item is selected) |

> ruby-lsp runs `bundle install` for its bundle on first attach, so the first open of a
> Ruby file in a project takes a few seconds. terraform-ls warns on single files — open
> the directory for full functionality.

---

## Format & lint

- Save formats the buffer automatically (see house deviations). To inspect what runs:
  `:ConformInfo`.
- The binaries (`ruff`, `prettier`, `shellcheck`) come from **mise**, so they're the
  same versions your shell and CI use.

---

## Git (gitsigns)

- Add/change/delete **signs in the gutter** for the current buffer vs HEAD.
- No keymaps bound — drive it via `:Gitsigns`: `preview_hunk`, `stage_hunk`,
  `reset_hunk`, `blame_line`, `diffthis`, `toggle_current_line_blame`.

---

## Windows, panes & motion

| What | How |
|---|---|
| Move between splits **and tmux panes** | `C-h/j/k/l` (no leader; seamless across vim↔tmux) |
| Resize mode | `\w` → then `h/j/k/l`, `Enter` to confirm, `q` to cancel |
| Close buffer, keep the window | `\q` |
| Save | `\s` |
| Leave terminal mode | `C-q` |
| Jump to a unique char on the line | `f`/`F`/`t`/`T` — quick-scope highlights the targets |

---

## Editing niceties

- **endwise** closes Ruby/Lua/sh blocks (`end`) as you type.
- **matchmaker** highlights other occurrences of the word under the cursor.
- **vimade** fades inactive windows so the focused one stands out.
- Indent guides (`┆`) and a subtle **column marker at 80 and 120**.

---

## Clojure REPL (Conjure + vim-jack-in)

Start a REPL with `:Clj` (deps.edn) or `:Lein` (Leiningen) — Conjure connects
automatically. **parinfer** keeps parens balanced structurally as you edit.

Conjure mappings (localleader `,`):

| What | How |
|---|---|
| Eval current form | `,ee` |
| Eval root (top-level) form | `,er` |
| Eval word | `,ew` |
| Eval visual selection / motion | `E` |
| Eval whole buffer | `,eb` |
| Eval previous result inline | `,ep` |
| Go to definition | `gd` |
| Docs for word | `K` |
| Open log (split / vsplit / tab) | `,ls` / `,lv` / `,lt` |
| Toggle log window | `,lg` |

---

## Managing the setup

| What | How |
|---|---|
| Plugins (install/update/clean) | `:Lazy` — `U` updates and rewrites the tracked `lazy-lock.json` |
| Language servers | `:Mason` |
| Which server attached here | `:LspInfo` (a.k.a. `:checkhealth vim.lsp`) |
| Diagnose anything | `:checkhealth` |
| Treesitter parsers | `:TSInstall <lang>` / `:TSUpdate` |
