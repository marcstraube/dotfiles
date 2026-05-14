# Dotfiles

Bare git repo for Arch Linux with modular bash config, Neovim (Lua), and Starship prompt.

## Contents

| Path                          | Description                                                                |
| ----------------------------- | -------------------------------------------------------------------------- |
| `.bashrc.d/`                  | Modular bash configuration (environment, aliases, functions, completions) |
| `.config/nvim/`               | Neovim config with Lazy.nvim, LSP, Treesitter, Telescope, AI plugins       |
| `.config/starship.toml`       | Starship prompt — Spectrum Powerline theme with Nerd Font icons            |
| `.config/blesh/init.sh`       | ble.sh config — syntax highlighting, autosuggestions, Catppuccin faces     |
| `.config/atuin/config.toml`   | Atuin config — fuzzy history search, vim-insert keymap, no sync            |
| `.gitignore`                  | Ignore-all strategy (only explicitly added files are tracked)              |

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

The canonical package list lives in [`dependencies.sh`](dependencies.sh) (single source of
truth — also consumed by `install.sh` and `dotfiles health`). To install everything:

```bash
# shellcheck disable=SC1091
source ~/Projekte/dotfiles/dependencies.sh
sudo pacman -S "${DOTFILES_DEPS[@]##*:}"
paru -S blesh-git  # AUR — ble.sh 0.4+
```

Or simply run `install.sh` — it does the dependency check and prints the exact
`pacman` command for whatever is missing.

## Install

### Quick install

```bash
curl -Lks https://raw.githubusercontent.com/marcstraube/dotfiles/master/install.sh | bash
```

### Manual setup

```bash
# Pick any location — just keep it consistent with DOTFILES_DIR below
git clone --bare git@github.com:marcstraube/dotfiles.git ~/Projekte/dotfiles

# Temporary alias for setup
alias dotfiles='/usr/bin/git --git-dir=$HOME/Projekte/dotfiles/ --work-tree=$HOME'

# Checkout files into $HOME (backup conflicts first if needed)
dotfiles checkout

# Hide untracked files
dotfiles config --local status.showUntrackedFiles no

# Skip meta files so they don't appear in $HOME
dotfiles update-index --skip-worktree README.md install.sh pre-push.sh dependencies.sh .claude/CLAUDE.md

# Wire up the pre-push lint hook (bare repo, so $gitdir/hooks/ IS the hooks dir)
ln -sf ../pre-push.sh ~/Projekte/dotfiles/hooks/pre-push
```

### Repo location

The `dotfiles` shell function (in `.bashrc.d/12-aliases-git`) reads `$DOTFILES_DIR`,
defaulting to `~/Projekte/dotfiles`. To use a different location, export the
variable before the bashrc.d files are sourced — easiest in `99-custom-aliases`
(machine-local, untracked):

```bash
export DOTFILES_DIR="$HOME/wherever/dotfiles"
```

The installer reads the same variable, so `DOTFILES_DIR=… ./install.sh` or
`--dir` both work.

### Options

```
install.sh [--repo <url>] [--dir <path>]
```

| Flag     | Env var         | Default                                     | Description         |
| -------- | --------------- | ------------------------------------------- | ------------------- |
| `--repo` | `DOTFILES_REPO` | `git@github.com:marcstraube/dotfiles.git`   | Repository URL      |
| `--dir`  | `DOTFILES_DIR`  | `~/Projekte/dotfiles`                       | Bare repo location  |

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

| Alias       | Command                                                        |
| ----------- | -------------------------------------------------------------- |
| `dfs`       | `dotfiles status -sb`                                          |
| `dfa`       | `dotfiles add -f`                                              |
| `dfc`       | `dotfiles commit -S -m`                                        |
| `dfp`       | `dotfiles push`                                                |
| `dfsync`    | `dotfiles sync` (fetch + pull --rebase + push)                 |
| `dfhealth`  | `dotfiles health`                                              |
| `dfmeta`    | `dotfiles meta` (commit meta files from `$DOTFILES_DIR`)       |
| `dfem`      | `dotfiles edit-meta` (edit in `$EDITOR`, prompt to commit)     |

### Health check

```bash
dotfiles health   # Colored checklist: repo, deps, config, sync status
```

### Meta files

Some files describe the repo itself rather than the user's `$HOME`:

| File                | Role                                                     |
| ------------------- | -------------------------------------------------------- |
| `README.md`         | This document                                            |
| `install.sh`        | Bootstrap installer                                      |
| `pre-push.sh`       | Git pre-push lint hook (`bash -n` + `shellcheck`)        |
| `dependencies.sh`   | Single source of truth for tool list (binary:package)    |
| `.claude/CLAUDE.md` | Project instructions for Claude Code                     |

They are **tracked at the same paths** in git but `--skip-worktree` is set so
they never appear in `$HOME`. The canonical on-disk location is the bare-repo
directory (`$DOTFILES_DIR`). `_dotfiles_meta` reads files from there, hashes them
with `git hash-object -w`, and commits via plumbing.

```bash
dotfiles meta                          # Default message
dotfiles meta "docs: update README"    # Custom message
dfmeta "docs: add install script"      # Shortcut
dotfiles edit-meta                     # Open in $EDITOR, prompt to commit
```

### Pre-push hook

`pre-push.sh` runs `bash -n` and `shellcheck -S warning` against every tracked
shell script before any push (`.bashrc`, `.bashrc.d/*`, `install.sh`,
`pre-push.sh`). `install.sh` activates it by symlinking
`$DOTFILES_DIR/hooks/pre-push → ../pre-push.sh`. For a bare repo, the GIT_DIR
hooks directory is the active one — no `core.hooksPath` needed.

If you ever need to bypass it (don't, unless you really mean it):

```bash
dotfiles push --no-verify
```

### Systemd timers

`install.sh` discovers every tracked `.config/systemd/user/*.timer` via
`git ls-tree` and enables them with `systemctl --user enable --now`. Currently:

| Timer                  | Purpose                                                                                          |
| ---------------------- | ------------------------------------------------------------------------------------------------ |
| `checkupdates.timer`   | Hourly Arch update count → `~/.cache/banner-updates`, displayed by the login banner             |

`dotfiles health` checks each tracked timer is both `enabled` and `active`.

## Structure

### Bash (`.bashrc.d/`)

Sourced numerically by `~/.bashrc`. Each file handles one concern:

| File                 | Purpose                                                       |
| -------------------- | ------------------------------------------------------------- |
| `01-environment`     | PATH, XDG dirs, default apps                                  |
| `02-history`         | History size, dedup, timestamps                               |
| `03-options`         | Shell options (cdspell, globstar, etc.) + ble.sh guards       |
| `04-secrets`         | sops + age secrets management (secrets-edit, secrets-show)    |
| `05-banner`          | Terminal welcome banner                                       |
| `10-aliases-basic`   | Core aliases (ls, cp, grep, etc.)                             |
| `11-aliases-modern`  | Modern tool replacements (eza, bat, etc.)                     |
| `12-aliases-git`     | Git aliases + dotfiles management                             |
| `13-aliases-nvim`    | Neovim aliases                                                |
| `20-functions`       | Shell functions (extract, mkcd, etc.)                         |
| `21-dothelp`         | Quick reference help system                                   |
| `30-nvm`             | Node Version Manager lazy-loading                             |
| `40-completion`      | Bash completions                                              |
| `50-prompt`          | Starship prompt init                                          |
| `99-custom-aliases`  | Machine-local overrides (not tracked)                         |

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
