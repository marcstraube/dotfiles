-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                      lazy.nvim Plugin Manager Setup                      ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- lazy.nvim Bootstrap (automatische Installation)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvim Setup
require("lazy").setup({
    -- Plugins werden automatisch aus lua/plugins/*.lua geladen
    spec = {
        { import = "plugins" },
    },

    -- Lazy.nvim Optionen
    defaults = {
        lazy = false,  -- Standardmäßig NICHT lazy loaden
        version = false,  -- Immer latest commit nutzen
    },

    -- UI Settings
    ui = {
        border = "rounded",  -- Abgerundete Fenster-Borders
        icons = {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },

    -- Performance
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },

    -- Checker (auto-update benachrichtigung)
    checker = {
        enabled = true,   -- Auto-check für Updates
        notify = false,   -- Keine Notifications (kann nervig sein)
    },

    -- Change detection
    change_detection = {
        enabled = true,   -- Auto-reload wenn Config geändert wird
        notify = false,   -- Keine Notifications
    },
})

-- Keybindings für lazy.nvim
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy Plugin Manager" })
