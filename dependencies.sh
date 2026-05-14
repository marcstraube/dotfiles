# Single source of truth for dotfiles dependencies.
# Sourced by install.sh (uses package name) and _dotfiles_health (uses binary name).
# Format per entry: "binary:package"
DOTFILES_DEPS=(
    "starship:starship"
    "nvim:neovim"
    "eza:eza"
    "bat:bat"
    "rg:ripgrep"
    "fd:fd"
    "fzf:fzf"
    "zoxide:zoxide"
    "dust:dust"
    "duf:duf"
    "btop:btop"
    "procs:procs"
    "age:age"
    "sops:sops"
    "direnv:direnv"
    "atuin:atuin"
)
