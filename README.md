# dotfiles

Personal dotfiles for Linux/WSL (Ubuntu). Managed with [GNU stow]; toolchains with
[mise]; secrets with [sops] + [age].

## New machine

```sh
git clone <this-repo> ~/Projects/dotfiles
cd ~/Projects/dotfiles
./bootstrap.sh
```

`bootstrap.sh` is Ubuntu/apt-only and defensive — it installs missing dependencies,
links the stow packages, installs the mise toolchain, and sets up tmux/neovim plugins.
It will **stop and ask for your age key** before touching secrets (it never generates
one for you). On a fresh machine, copy your existing key into place first:

```sh
mkdir -p ~/.config/sops/age
cp /path/to/your/keys.txt ~/.config/sops/age/keys.txt
```

After it finishes, seed your real secret values:

```sh
sops zsh/.zsh/secrets.enc.env
```

## Layout

Each top-level directory is a stow package whose tree mirrors `$HOME`:

| Package  | Links into            |
|----------|-----------------------|
| `zsh`      | `~/.zshrc`, `~/.zsh/`              |
| `tmux`     | `~/.tmux.conf`                    |
| `nvim`     | `~/.config/nvim/`                 |
| `mise`     | `~/.config/mise/`                 |
| `claude`   | `~/.claude/`                      |
| `starship` | `~/.config/starship.toml`         |
| `git`      | `~/.gitconfig`, `~/.config/git/`  |

Add/remove a package with `stow -t ~ <pkg>` / `stow -D -t ~ <pkg>`; re-link after adding
files with `stow -R -t ~ <pkg>`. The `-t ~` is required because this repo lives outside
`$HOME` — without it, stow targets the repo's parent directory. `bootstrap.sh` already
passes the right `-d`/`-t`.

## Git identity

The committed `~/.gitconfig` holds only machine-independent settings and ends with
`[include] path = ~/.gitconfig.local`. The per-machine email lives in that local file
(not committed), so personal/work identities stay per-machine. `bootstrap.sh` prompts for
the email and writes `~/.gitconfig.local` when it's unset; add work `[includeIf]` blocks
there as needed.

## Toolchains (mise)

Global versions live in `mise/.config/mise/config.toml`; override per-project with a
local `mise.toml`. Note: `mise use -g …` rewrites the global config and can replace the
stow symlink with a real file — treat the repo copy as canonical and re-`stow mise` if
that happens. Rust is mise-managed; reach for rustup directly only if a project needs a
nightly toolchain or specific components/targets.

## Secrets (sops + age)

Secrets live encrypted in `zsh/.zsh/secrets.enc.env` (committed) and are decrypted into
the environment at shell startup via `sops`. The age private key
(`~/.config/sops/age/keys.txt`) is machine-local and never committed — carry it to new
machines out-of-band. Public recipients are configured in `.sops.yaml`. Edit secrets
with `sops zsh/.zsh/secrets.enc.env`.
