-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                    NeoVim Configuration - init.lua                       ║
-- ║                    Modern Lua-based Config 2026                          ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Leader key must be set BEFORE lazy.nvim
vim.g.mapleader = " "       -- Space as leader key
vim.g.maplocalleader = " "  -- Space as local leader

-- Load core configuration
require("core.options")     -- Vim options (line numbers, tabs, etc.)
require("core.lazy")        -- Plugin manager setup
require("core.keymaps")     -- Keybindings

-- Performance: Disable some built-in plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
