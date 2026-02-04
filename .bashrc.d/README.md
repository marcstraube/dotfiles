# Bash Configuration Documentation

Modern, modular Bash configuration with numbered loading order.

## 📁 File Structure

Files are loaded in numerical order:

```
~/.bashrc.d/
├── 01-environment      # Environment variables, PATH, XDG dirs
├── 02-history          # History configuration (eternal, sync)
├── 03-options          # Shell options (vi mode, globbing, etc.)
├── 10-aliases-basic    # Basic aliases (ls, cd, cp, etc.)
├── 11-aliases-modern   # Modern tool aliases (eza, bat, ripgrep)
├── 12-aliases-git      # Git aliases (comprehensive)
├── 13-aliases-nvim     # NeoVim aliases
├── 20-functions        # Shell functions (extract, mkcd, etc.)
├── 30-nvm              # Node Version Manager (lazy loaded)
├── 40-completion       # Bash completion, fzf
├── 50-prompt           # Starship prompt
└── 99-custom-aliases   # Auto-generated (via mkalias/rmalias)
```

## ✨ Key Features

### 🐛 Bug Fixes from Old Config
- ✅ `extract()` - Fixed `$FILE` → `$1` bug
- ✅ `compress()` - Removed erroneous `shift`
- ✅ `nvimdiff` - Changed from alias to function

### 🚀 Performance Improvements
- **Lazy NVM loading** - Shell starts ~500ms faster!
- **zoxide** - Smarter, faster `cd`
- **Numbered files** - Explicit load order

### 🎨 Modern Tools (auto-detected)
When installed, these replace basic commands:
- `eza` → modern `ls` (icons, git status)
- `bat` → modern `cat` (syntax highlighting)
- `ripgrep` → modern `grep` (faster, smarter)
- `fd` → modern `find` (simpler syntax)
- `zoxide` → modern `cd` (frecency-based)
- `dust` → modern `du` (visual disk usage)
- `duf` → modern `df` (pretty disk info)
- `btop` → modern `top` (beautiful system monitor)

### 🎯 Git Workflow
Comprehensive git aliases:
```bash
gs    # git status -sb (short)
ga    # git add
gc    # git commit -v
gp    # git push
gpl   # git pull
gl    # git log (pretty)
gco   # git checkout
gcb   # git checkout -b
```

**Dotfiles shortcuts:**
```bash
dotfiles / df   # Main command
dfs             # Status
dfa <file>      # Add file
dfc "msg"       # Commit (signed)
dfp             # Push
```

### 🔍 fzf Integration
Fuzzy search everything:
- `Ctrl+R` - Fuzzy history search
- `Ctrl+T` - Fuzzy file search
- `Alt+C` - Fuzzy cd
- `fcd` - Fuzzy find and cd to directory
- `fe` - Fuzzy find and edit file
- `gcof` - Fuzzy git checkout branch

### 🛡️ Safety Features
- `rm -I` - Prompts before deleting >3 files
- `cp -i` - Prompts before overwrite
- `mv -i` - Prompts before overwrite
- `--preserve-root` on chmod/chown/chgrp

### 📝 Custom Aliases
```bash
mkalias <name> "<command>"  # Create persistent alias
rmalias <name>              # Remove alias
```

Aliases are stored in `99-custom-aliases` and survive shell restarts.

## 🔧 Installation Requirements

### Essential (already have)
- bash
- git
- nvim

### Recommended
```bash
# Arch Linux
sudo pacman -S starship fzf fd ripgrep bat eza zoxide dust duf btop

# Or individually:
sudo pacman -S starship    # Modern prompt
sudo pacman -S fzf         # Fuzzy finder
sudo pacman -S fd          # Modern find
sudo pacman -S ripgrep     # Modern grep
sudo pacman -S bat         # Modern cat
sudo pacman -S eza         # Modern ls
sudo pacman -S zoxide      # Smarter cd
sudo pacman -S dust        # Modern du
sudo pacman -S duf         # Modern df
sudo pacman -S btop        # Modern top
```

**Note:** Config works fine without these! It auto-detects and falls back to basic commands.

## 📚 Usage Examples

### Extract any archive
```bash
extract archive.tar.gz
extract file.zip
extract data.7z
```

### Compress files
```bash
compress backup.tar.gz folder/
compress project.zip *.js *.css
```

### Quick navigation
```bash
...        # cd ../..
....       # cd ../../..
-          # cd to previous directory
mkcd test  # mkdir + cd in one
```

### Git workflow
```bash
gcb feature/new-thing   # Create and checkout branch
ga .                    # Stage all
gcs "feat: add thing"   # Signed commit
gp                      # Push
```

### Dotfiles management
```bash
dfs                          # Check status
dfa ~/.config/nvim/          # Add nvim config
dfc "feat(nvim): update"     # Commit
dfp                          # Push
```

### Fuzzy search (requires fzf)
```bash
fcd        # Fuzzy find directory and cd
fe         # Fuzzy find file and edit
gcof       # Fuzzy git checkout
Ctrl+R     # Fuzzy history search
```

### Notes
```bash
note "Meeting at 3pm"      # Quick note
note                       # Open today's note in nvim
```

## 🎨 Prompt (Starship)

Config: `~/.config/starship.toml`

Shows:
- Username@hostname
- Current directory (with icons)
- Git branch + status
- Command duration (if >2s)
- Current time
- Language versions (Node, Python, Rust, PHP)

## 🔄 Reload Configuration

```bash
source ~/.bashrc
# or
exec bash
```

## 📝 Customization

### Add your own files
Create files with higher numbers (e.g., `60-myconfig`) to load after all defaults.

### Override defaults
Files load in order, so later files override earlier ones.

### Disable a module
Rename it (add `.disabled` extension):
```bash
mv ~/.bashrc.d/11-aliases-modern{,.disabled}
```

## 🐛 Troubleshooting

### Slow shell startup?
Check if NVM is lazy-loading:
```bash
time bash -ic exit
```
Should be <0.5s

### Missing commands?
Install recommended tools (see above) or they'll fall back to basic versions.

### Starship not showing?
Install it:
```bash
sudo pacman -S starship
# or
curl -sS https://starship.rs/install.sh | sh
```

## 📖 Resources

- [Starship docs](https://starship.rs/)
- [fzf wiki](https://github.com/junegunn/fzf/wiki)
- [Bash manual](https://www.gnu.org/software/bash/manual/)

---

**Enjoy your modern Bash setup! 🚀**
