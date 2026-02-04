-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                      Dashboard - alpha-nvim                              ║
-- ║                   Modern start screen for NeoVim                         ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- ASCII Art Logo
        dashboard.section.header.val = {
            "                                                     ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
            "                                                     ",
        }

        -- Buttons / Menu
        dashboard.section.buttons.val = {
            dashboard.button("n", "  New File", ":enew<CR>"),
            dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
            dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
            dashboard.button("g", "  Find Word", ":Telescope live_grep<CR>"),
            dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
            dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
            dashboard.button("m", "  Mason (LSP)", ":Mason<CR>"),
            dashboard.button("l", "  Lazy (Plugins)", ":Lazy<CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>"),
        }

        -- Footer
        local function footer()
            local total_plugins = #vim.tbl_keys(require("lazy").plugins())
            local datetime = os.date("  %Y-%m-%d   %H:%M:%S")
            local version = vim.version()
            local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

            return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
        end

        dashboard.section.footer.val = footer()

        -- Layout
        dashboard.config.layout = {
            { type = "padding", val = 2 },
            dashboard.section.header,
            { type = "padding", val = 2 },
            dashboard.section.buttons,
            { type = "padding", val = 1 },
            dashboard.section.footer,
        }

        -- Disable folding on alpha buffer
        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])

        -- Setup
        alpha.setup(dashboard.config)

        -- Keybinding to open dashboard
        vim.keymap.set("n", "<leader>h", ":Alpha<CR>", { desc = "Open Dashboard" })
    end,
}
