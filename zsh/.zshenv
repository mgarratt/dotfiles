# Runs for every zsh invocation (before .zshrc). Keep this minimal.

# Nix (guarded — no-op if Nix isn't installed on this machine)
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
