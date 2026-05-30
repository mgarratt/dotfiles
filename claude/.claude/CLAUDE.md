# Global instructions

Personal, machine-independent preferences for Claude Code. Project-specific rules
belong in that project's own `CLAUDE.md` / `AGENTS.md`, not here.

## Environment

- Linux / WSL (Ubuntu) only. Assume `apt` for system packages.
- Language/tool versions are managed by `mise`; prefer `mise`-provided binaries.

## Working style

- Keep changes minimal and match the surrounding code's style.
- Don't commit or push unless asked.
- Never print or commit secrets. On this machine secrets are decrypted at shell
  startup from a sops+age file — treat any token in the environment as sensitive.

<!-- Flesh out with your own preferences over time. -->
