# Dotfiles

Bare git repo for Arch Linux with modular bash config, Neovim (Lua), and Starship prompt.

## Contents

| Path | Description |
|---|---|
| `.bashrc.d/` | Modular bash configuration (environment, aliases, functions, completions) |
| `.config/nvim/` | Neovim config with Lazy.nvim, LSP, Treesitter, Telescope, AI plugins |
| `.config/starship.toml` | Starship prompt — Spectrum Powerline theme with Nerd Font icons |
| `.config/blesh/init.sh` | ble.sh config — syntax highlighting, autosuggestions, Catppuccin faces |
| `.config/atuin/config.toml` | Atuin config — fuzzy history search, vim-insert keymap, no sync |
| `.gitignore` | Ignore-all strategy (only explicitly added files are tracked) |

## Dependencies

- **Shell:** bash
- **Font:** [Nerd Font](https://www.nerdfonts.com/) (e.g. JetBrainsMono Nerd Font)
- **Prompt:** [starship](https://starship.rs/)
- **Editor:** [neovim](https://neovim.io/) >= 0.10
- **Line editor:** [ble.sh](https://github.com/akinomyoga/ble.sh) >= 0.4 (syntax highlighting, autosuggestions)
- **Modern CLI tools:** eza, bat, ripgrep, fd, fzf, zoxide, dust, duf, btop, procs
- **History:** [atuin](https://atuin.sh/) (optional, fuzzy shell history with SQLite backend)
- **Secrets:** [age](https://github.com/FiloSottile/age) + [sops](https://github.com/getsops/sops) (optional, for encrypted secrets)

### Arch Linux

```bash
sudo pacman -S bash starship neovim eza bat ripgrep fd fzf zoxide dust duf btop procs age sops atuin
paru -S blesh-git  # AUR — ble.sh 0.4+
```

## Install

### Quick install

```bash
curl -Lks https://raw.githubusercontent.com/marcstraube/dotfiles/master/install.sh | bash
```

### Manual setup

```bash
git clone --bare git@github.com:marcstraube/dotfiles.git ~/Code/dotfiles

# Temporary alias for setup
alias dotfiles='/usr/bin/git --git-dir=$HOME/Code/dotfiles/ --work-tree=$HOME'

# Checkout files into $HOME (backup conflicts first if needed)
dotfiles checkout

# Hide untracked files
dotfiles config --local status.showUntrackedFiles no

# Skip meta files so they don't appear in $HOME
dotfiles update-index --skip-worktree README.md install.sh .claude/CLAUDE.md
```

### Options

```
install.sh [--repo <url>] [--dir <path>]
```

| Flag | Default | Description |
|---|---|---|
| `--repo` | `git@github.com:marcstraube/dotfiles.git` | Repository URL |
| `--dir` | `~/Code/dotfiles` | Bare repo location |

The installer automatically backs up conflicting files to `~/.dotfiles-backup/`.

## Usage

The `dotfiles` function works like `git` but operates on your home directory:

```bash
dotfiles status -sb          # Short status
dotfiles add -f ~/.new-file  # Add file (needs -f due to ignore-all)
dotfiles commit -S -m "msg"  # Signed commit
dotfiles push                # Push to remote
```

### Shortcuts

| Alias | Command |
|---|---|
| `dfs` | `dotfiles status -sb` |
| `dfa` | `dotfiles add -f` |
| `dfc` | `dotfiles commit -S -m` |
| `dfp` | `dotfiles push` |
| `dfhealth` | `dotfiles health` |
| `dfem` | `dotfiles edit-meta` |

### Health check

```bash
dotfiles health   # Colored checklist: repo, deps, config, sync status
```

### Meta files

Files like `README.md` and `install.sh` live in the bare-repo directory (`~/Code/dotfiles/`),
not in `$HOME`. To commit them into the git history:

```bash
dotfiles meta                          # Default message
dotfiles meta "docs: update README"    # Custom message
dfmeta "docs: add install script"      # Shortcut
dotfiles edit-meta                     # Open in $EDITOR, prompt to commit
```

## Structure

### Bash (`.bashrc.d/`)

Sourced numerically by `~/.bashrc`. Each file handles one concern:

| File | Purpose |
|---|---|
| `01-environment` | PATH, XDG dirs, default apps |
| `02-history` | History size, dedup, timestamps |
| `03-options` | Shell options (cdspell, globstar, etc.) + ble.sh guards |
| `04-secrets` | sops + age secrets management (secrets-edit, secrets-show) |
| `05-banner` | Terminal welcome banner |
| `10-aliases-basic` | Core aliases (ls, cp, grep, etc.) |
| `11-aliases-modern` | Modern tool replacements (eza, bat, etc.) |
| `12-aliases-git` | Git aliases + dotfiles management |
| `13-aliases-nvim` | Neovim aliases |
| `20-functions` | Shell functions (extract, mkcd, etc.) |
| `21-dothelp` | Quick reference help system |
| `30-nvm` | Node Version Manager lazy-loading |
| `40-completion` | Bash completions |
| `50-prompt` | Starship prompt init |
| `99-custom-aliases` | Machine-local overrides (not tracked) |

### Neovim (`.config/nvim/`)

Lua-based config with Lazy.nvim plugin manager. See `.config/nvim/README.md` for details.

### Starship (`.config/starship.toml`)

Spectrum Powerline theme with pixelated transitions, rounded caps, and Nerd Font XDG directory icons.

### ble.sh (`.config/blesh/init.sh`)

Syntax highlighting with Catppuccin-inspired faces, history-based autosuggestions,
vi-mode cursor shapes (block/beam). Requires `blesh-git` (0.4+) for truecolor support.

### Atuin (`.config/atuin/config.toml`)

Fuzzy shell history search (Ctrl+R) with SQLite backend. Config: compact UI, vim-insert keymap,
history filter mirroring HISTIGNORE, sync disabled. Bash HISTFILE continues as fallback.
