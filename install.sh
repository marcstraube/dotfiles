#!/usr/bin/env bash
# Dotfiles installer — bare git repo pattern
# Usage:
#   curl -Lks https://raw.githubusercontent.com/marcstraube/dotfiles/master/install.sh | bash
#   or: install.sh [--repo <url>] [--dir <path>]

set -euo pipefail

REPO="${DOTFILES_REPO:-git@github.com:marcstraube/dotfiles.git}"
DOTDIR="${DOTFILES_DIR:-$HOME/Projekte/dotfiles}"
BACKUPDIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DEPS=(bash starship neovim eza bat ripgrep fd fzf zoxide dust duf btop procs)
META_FILES=(README.md install.sh pre-push.sh .claude/CLAUDE.md)

# ---------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
    case "$1" in
        --repo) REPO="$2"; shift 2 ;;
        --dir)  DOTDIR="$2"; shift 2 ;;
        *)      echo "Unknown option: $1"; exit 1 ;;
    esac
done

_dotfiles() {
    /usr/bin/git --git-dir="$DOTDIR" --work-tree="$HOME" "$@"
}

# ---------------------------------------------------------------------------

echo "==> Cloning bare repo into $DOTDIR"
if [[ -d "$DOTDIR" ]]; then
    echo "  Directory already exists, skipping clone"
else
    git clone --bare "$REPO" "$DOTDIR"
fi

echo "==> Checking out files into \$HOME"
if ! _dotfiles checkout 2>/dev/null; then
    echo "  Backing up conflicting files to $BACKUPDIR"
    mkdir -p "$BACKUPDIR"
    _dotfiles checkout 2>&1 \
        | grep -E "^\t" \
        | awk '{print $1}' \
        | while read -r f; do
            mkdir -p "$BACKUPDIR/$(dirname "$f")"
            mv "$HOME/$f" "$BACKUPDIR/$f"
            echo "    $f → $BACKUPDIR/$f"
        done
    _dotfiles checkout
fi

echo "==> Configuring repo"
_dotfiles config --local status.showUntrackedFiles no

echo "==> Setting skip-worktree on meta files"
for f in "${META_FILES[@]}"; do
    _dotfiles update-index --skip-worktree "$f" 2>/dev/null || true
done

echo "==> Checking dependencies"
missing=()
for dep in "${DEPS[@]}"; do
    case $dep in
        neovim)  command -v nvim &>/dev/null || missing+=("$dep") ;;
        ripgrep) command -v rg &>/dev/null   || missing+=("$dep") ;;
        *)       command -v "$dep" &>/dev/null || missing+=("$dep") ;;
    esac
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "  Missing: ${missing[*]}"
    if command -v pacman &>/dev/null; then
        echo "  Install: sudo pacman -S ${missing[*]}"
    fi
else
    echo "  All dependencies found"
fi

echo "==> Installing git pre-push hook"
if [[ -f "$DOTDIR/pre-push.sh" ]]; then
    ln -sf ../pre-push.sh "$DOTDIR/hooks/pre-push"
    chmod +x "$DOTDIR/pre-push.sh"
    echo "  Linked $DOTDIR/hooks/pre-push -> ../pre-push.sh"
else
    echo "  pre-push.sh not found, skipping"
fi

echo "==> Enabling user systemd timers"
if command -v systemctl &>/dev/null; then
    systemctl --user daemon-reload
    while IFS= read -r timer_path; do
        timer="${timer_path##*/}"
        echo "  Enabling $timer"
        systemctl --user enable --now "$timer"
    done < <(_dotfiles ls-tree -r --name-only HEAD | grep -E '^\.config/systemd/user/.+\.timer$' || true)
else
    echo "  systemctl not found, skipping"
fi

echo ""
echo "==> Done!"
echo ""
echo "The 'dotfiles' shell function (in .bashrc.d/12-aliases-git) defaults to"
echo "  DOTFILES_DIR=\$HOME/Projekte/dotfiles"
if [[ "$DOTDIR" != "$HOME/Projekte/dotfiles" ]]; then
    echo ""
    echo "You installed to a different location. Add this to ~/.bashrc.d/99-custom-aliases:"
    echo "  export DOTFILES_DIR=\"$DOTDIR\""
fi
echo ""
echo "Then: source ~/.bashrc && dotfiles status"
