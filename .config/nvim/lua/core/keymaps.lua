-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          Keybindings & Mappings                          ║
-- ║                                                                          ║
-- ║  Leader key: Space                                                       ║
-- ║  Use <leader>? to see all available keybindings (which-key)              ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ General Keybindings                                                      │
-- └──────────────────────────────────────────────────────────────────────────┘

-- Clear search highlighting with <Esc>
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better window navigation (keep Ctrl+hjkl from old config)
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows with arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Better indenting (stay in visual mode)
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page" })
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Paste without yanking in visual mode
keymap("v", "p", '"_dP', { desc = "Paste without yank" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Leader Key Mappings                                                      │
-- └──────────────────────────────────────────────────────────────────────────┘

-- File operations
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all without saving" })

-- Buffer operations
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
keymap("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Split windows
keymap("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
keymap("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Tabs
keymap("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader>tj", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader>tk", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Terminal mode mappings
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
keymap("t", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Go to left window" })
keymap("t", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Go to lower window" })
keymap("t", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Go to upper window" })
keymap("t", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Go to right window" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Plugin-specific keybindings are in their respective plugin config files │
-- │ - Telescope: lua/plugins/telescope.lua                                  │
-- │ - LSP: lua/plugins/lsp.lua                                              │
-- │ - nvim-tree: lua/plugins/nvim-tree.lua                                  │
-- │ - Git: lua/plugins/git.lua                                              │
-- │ - AI: lua/plugins/ai.lua                                                │
-- └──────────────────────────────────────────────────────────────────────────┘
