-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                         Vim Options & Settings                           ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local opt = vim.opt

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Suppress Deprecation Warnings (NeoVim 0.11+)                            │
-- └──────────────────────────────────────────────────────────────────────────┘
-- Some plugins haven't updated to NeoVim 0.11+ yet
-- Add backwards compatibility shims to suppress warnings
vim.lsp.get_active_clients = vim.lsp.get_clients
vim.lsp.buf_get_clients = function(bufnr)
    return vim.lsp.get_clients({ bufnr = bufnr })
end

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ UI & Appearance                                                          │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.number = true              -- Show line numbers
opt.relativenumber = true      -- Relative line numbers (for vim motions)
opt.cursorline = true          -- Highlight current line
opt.termguicolors = true       -- True color support (important for modern themes)
opt.signcolumn = "yes"         -- Always show sign column (for Git, LSP diagnostics)
opt.colorcolumn = "80"         -- 80-character marker
opt.showmode = false           -- Don't show mode (lualine does this)
opt.wrap = true                -- Wrap lines
opt.linebreak = true           -- Break at word boundaries
opt.breakindent = true         -- Indent wrapped lines
opt.showbreak = "↪ "           -- Prefix for wrapped lines
opt.list = true                -- Show invisible characters
opt.listchars = {              -- Which invisible characters to show
    tab = "→ ",
    trail = "·",
    nbsp = "␣",
    extends = "⟩",
    precedes = "⟨",
}

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Indentation & Tabs                                                       │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.expandtab = true           -- Convert tabs to spaces
opt.shiftwidth = 4             -- Number of spaces for indentation
opt.tabstop = 4                -- Number of spaces for tab character
opt.softtabstop = 4            -- Number of spaces when pressing Tab
opt.smartindent = true         -- Smart auto-indentation
opt.autoindent = true          -- Maintain auto-indentation

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Search & Replace                                                         │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.ignorecase = true          -- Case-insensitive search
opt.smartcase = true           -- Case-sensitive when uppercase in pattern
opt.hlsearch = true            -- Highlight search results
opt.incsearch = true           -- Incremental search (while typing)

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Splits & Windows                                                         │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.splitbelow = true          -- Open horizontal splits below
opt.splitright = true          -- Open vertical splits to the right

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Files & Backup                                                           │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.swapfile = false           -- No swap files
opt.backup = false             -- No backup files
opt.undofile = true            -- Persistent undo (across sessions)
opt.undolevels = 10000         -- Many undo levels
opt.autowrite = true           -- Auto-save on buffer switch

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Completion & Wildmenu                                                    │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.wildmode = "longest:full,full"  -- Command-line completion mode
opt.wildignore = {             -- Ignore these files
    "*/tmp/*",
    "*.so",
    "*.swp",
    "*.zip",
    "*.pyc",
    "*.db",
    "*.sqlite",
    "*node_modules/*",
    "*vendor/*",
}
opt.completeopt = "menu,menuone,noselect"  -- Completion menu behavior

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Performance                                                              │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.updatetime = 250           -- Faster update (important for LSP)
opt.timeoutlen = 500           -- Time for which-key popup (ms) - increased for reliability
opt.lazyredraw = false         -- Don't lazy redraw (for modern terminals)

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Mouse & Clipboard                                                        │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.mouse = "a"                -- Enable mouse in all modes
opt.clipboard = "unnamedplus"  -- Use system clipboard

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Scrolling                                                                │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.scrolloff = 8              -- Minimum 8 lines above/below cursor
opt.sidescrolloff = 8          -- Minimum 8 columns left/right of cursor

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Misc                                                                     │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.confirm = true             -- Confirm on unsaved changes
opt.conceallevel = 0           -- Don't hide concealed text
opt.pumheight = 10             -- Completion menu height
opt.showmatch = true           -- Highlight matching brackets
opt.visualbell = true          -- Visual bell instead of beeping
