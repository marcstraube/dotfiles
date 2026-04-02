# Dotfiles Repository - Claude Code Instructions

## Repository Type: Bare Git Repo

This is a **bare git repository** with `$HOME` as work-tree.

### Git Commands

**NEVER use `git` directly. ALWAYS use:**
```bash
/usr/bin/git --git-dir="$(pwd)" --work-tree=$HOME <command>
```

**Adding new files:** Use absolute paths and `-f` flag (the .gitignore blocks everything by default).

## Commit Convention

Format: `type(scope): message`

- Scopes: `bash`, `nvim`, `starship`
- Types: `feat`, `fix`, `chore`, `refactor`, `docs`
- GPG signing is enabled globally

## Tracked File Structure

```
~/.bashrc.d/              # Modular bash config
~/.config/nvim/           # Neovim Lua config
~/.config/starship.toml   # Starship prompt
~/.gitignore              # Repo gitignore (ignore-all strategy)
~/README.md               # Repo documentation
~/install.sh              # Setup script
```

## Unicode / Nerd Font Rules

The Write tool **strips BMP Private Use Area characters** (U+E000-U+F8FF).
This includes Powerline separators, Nerd Font dev icons, etc.

**ALWAYS use TOML unicode escape sequences in double-quoted strings:**
```toml
# Correct:
format = "[\ue0b0](fg:cyan bg:green)"

# WRONG — character will be silently stripped:
format = "[](fg:cyan bg:green)"
```

Key codepoints used in starship.toml:
- `\ue0b0` — Powerline right triangle (segment transitions)
- `\ue0b4` — Powerline right semicircle (segment end cap)
- `\ue0b6` — Powerline left semicircle (segment start cap)
- `\ue0c4` — Pixelated transition (dotted fade between segments)
- `\ue0a0` — Git branch icon
- `\ue718` Node.js, `\ue73c` Python, `\ue73d` PHP, `\ue61e` C
