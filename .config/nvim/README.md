# Modern NeoVim Configuration 2026

A feature-rich, modern NeoVim configuration with LSP, AI integration (Claude & Gemini), and powerful editing tools.

## ✨ Features

- **LSP Support**: Full IDE features for PHP, JavaScript/TypeScript, Python, C, SQL, CSS/SCSS
- **AI Integration**: Claude and Gemini support via codecompanion.nvim
- **Smart Completion**: nvim-cmp with snippets
- **Fuzzy Finding**: Telescope for files, grep, buffers, etc.
- **File Explorer**: nvim-tree (modern NERDTree replacement)
- **Syntax Highlighting**: Treesitter AST-based parsing
- **Git Integration**: Gitsigns, LazyGit, Fugitive
- **Modern UI**: Lualine, Bufferline, which-key
- **Smart Editing**: Autopairs, surround, comments

## 📦 First Launch

When you first open NeoVim, lazy.nvim will automatically:
1. Install itself
2. Download all plugins
3. Install Treesitter parsers
4. Install LSP servers via Mason

**Just wait for everything to finish installing!**

## 🎨 Color Scheme

Currently using **Catppuccin Mocha** (similar to your Spectrum theme with #252525 background).

To switch themes, edit `lua/plugins/colorscheme.lua` and enable a different theme.

## ⌨️ Essential Keybindings

**Leader key: `Space`**

### Help System

| Key | Action |
|-----|--------|
| `<leader>?` | **Show ALL keybindings** (which-key) |
| `<leader>fk` | Search keymaps with Telescope |

### File Navigation

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | Find buffers |
| `<leader>fr` | Recent files |
| `<leader>fw` | Find word under cursor |

### LSP (Code Intelligence)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Show references |
| `K` | Hover documentation |
| `<leader>la` | Code action |
| `<leader>lr` | Rename symbol |
| `<leader>lf` | Format document |
| `[d` / `]d` | Previous/Next diagnostic |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | LazyGit (terminal UI) |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `[h` / `]h` | Previous/Next hunk |

### AI - Hybrid Setup (Claude Code CLI + Gemini)

**Two AI systems working together:**

#### Claude Code CLI (uses your Claude Max account!)
Prefix: `<leader>a`

| Key | Action |
|-----|--------|
| `<leader>aa` | Ask Claude (prompt) |
| `<leader>ae` | Explain selection (visual mode) |
| `<leader>ar` | Refactor selection (visual mode) |
| `<leader>af` | Fix selection (visual mode) |
| `<leader>aF` | Analyze current file |

**No API key needed!** Uses `claude` CLI with your Claude Max account.

#### Gemini (polished chat UI)
Prefix: `<leader>g`

| Key | Action |
|-----|--------|
| `<leader>gc` | Gemini chat (toggle) |
| `<leader>gp` | Gemini actions menu |
| `<leader>ge` | Explain selection (visual mode) |
| `<leader>gr` | Refactor selection (visual mode) |
| `<leader>gf` | Fix selection (visual mode) |
| `<leader>gt` | Write tests (visual mode) |

**Setup Gemini (FREE API):**
```bash
# Get free API key: https://makersuite.google.com/app/apikey
export GEMINI_API_KEY="your-gemini-api-key"
```

### Window Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<leader>sv` | Split vertically |
| `<leader>sh` | Split horizontally |
| `<leader>sx` | Close split |

### Terminal

| Key | Action |
|-----|--------|
| `<C-\>` | Toggle floating terminal |
| `<leader>tf` | Float terminal |
| `<leader>th` | Horizontal terminal |
| `<leader>tv` | Vertical terminal |
| `<Esc><Esc>` | Exit terminal mode |

### Editing

| Key | Action |
|-----|--------|
| `gcc` | Toggle comment on line |
| `gc{motion}` | Toggle comment on motion |
| `ys{motion}{char}` | Add surround (e.g., `ysiw"` to surround word with quotes) |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |
| `<Tab>` | Next completion item / Next snippet field |
| `<C-Space>` | Trigger completion |

### Buffers & Files

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>bd` | Delete buffer |
| `<leader>bn` / `<leader>bp` | Next/Previous buffer |

## 🛠 Managing Plugins

| Command | Description |
|---------|-------------|
| `:Lazy` | Open plugin manager |
| `:Lazy sync` | Update all plugins |
| `:Mason` | Open LSP/tool installer |
| `:TSUpdate` | Update Treesitter parsers |

## 📁 File Structure

```
~/.config/nvim/
├── init.lua              # Entry point
├── lua/
│   ├── core/
│   │   ├── options.lua   # Vim settings
│   │   ├── keymaps.lua   # Core keybindings
│   │   └── lazy.lua      # Plugin manager
│   └── plugins/
│       ├── colorscheme.lua
│       ├── nvim-tree.lua
│       ├── telescope.lua
│       ├── lsp.lua
│       ├── cmp.lua
│       ├── treesitter.lua
│       ├── ui.lua
│       ├── git.lua
│       ├── ai.lua
│       └── editing.lua
└── README.md
```

## 🎯 Next Steps

1. **Get Gemini Free API key**:
   - Visit: https://makersuite.google.com/app/apikey
   - Add to `~/.bashrc` or `~/.zshrc`: `export GEMINI_API_KEY="your-key"`

2. **Verify Claude Code CLI is working**:
   ```bash
   claude --version
   claude auth status
   ```

3. **Press `<leader>?`** to explore all keybindings

4. **Install language-specific tools** via `:Mason` if needed

5. **Customize** by editing files in `lua/plugins/`

## 🔧 Customization

- **Change colorscheme**: Edit `lua/plugins/colorscheme.lua`
- **Add plugins**: Create new files in `lua/plugins/`
- **Change keybindings**: Edit `lua/core/keymaps.lua` or plugin-specific files
- **Adjust LSP servers**: Edit `lua/plugins/lsp.lua`

## 📚 Learning Resources

- Vim motions: `:Tutor` (built-in tutorial)
- LSP features: Press `K` on any symbol to see documentation
- Which-key: Press `<leader>` and wait 300ms to see available keys
- Telescope: Press `<leader>fh` to search help tags

## 💡 Pro Tips

1. Use `<leader>ff` instead of file explorer for faster file opening
2. Learn vim motions: `ciw`, `dap`, `yiw`, etc.
3. Use `gcc` to comment lines quickly
4. Press `K` on any function/variable to see documentation
5. Use AI chat (`<leader>aa`) for code explanations and refactoring
6. Customize indentation per-project with `.editorconfig`

## 🐛 Troubleshooting

**Plugins not loading?**
- Run `:Lazy sync`

**LSP not working?**
- Run `:Mason` and check if language servers are installed
- Run `:LspInfo` to see active LSP clients

**Treesitter errors?**
- Run `:TSUpdate`

**Claude Code CLI not working?**
- Check if installed: `which claude`
- Check auth: `claude auth status`
- If not authenticated: `claude auth login`

**Gemini not working?**
- Check if API key is set: `:echo $GEMINI_API_KEY`
- Get free key at: https://makersuite.google.com/app/apikey
- Add to `~/.bashrc` or `~/.zshrc`

---

**Enjoy your modern NeoVim setup! 🚀**

Press `<leader>?` to get started!
