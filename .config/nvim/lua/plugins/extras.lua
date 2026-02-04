-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                     Extra Features - Fun & Power Pack                    ║
-- ║          Duck, Matrix, Colors, Zen Mode, and more!                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
    -- 🦆 Duck Debugger - Rubber Duck Programming
    {
        "tamton-aquib/duck.nvim",
        config = function()
            vim.keymap.set("n", "<leader>dd", function()
                require("duck").hatch()
            end, { desc = "Duck: Hatch 🦆" })

            vim.keymap.set("n", "<leader>dk", function()
                require("duck").cook()
            end, { desc = "Duck: Cook 🍗" })

            vim.keymap.set("n", "<leader>da", function()
                require("duck").hatch("🦀")  -- Crab mode!
            end, { desc = "Duck: Hatch Crab 🦀" })
        end,
    },

    -- 🟢 Matrix Rain - Cellular Automaton
    {
        "eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        config = function()
            vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Matrix Rain 🟢" })
            vim.keymap.set("n", "<leader>fms", "<cmd>CellularAutomaton scramble<CR>", { desc = "Matrix Scramble" })
            vim.keymap.set("n", "<leader>fmg", "<cmd>CellularAutomaton game_of_life<CR>", { desc = "Game of Life" })
        end,
    },

    -- 🎨 Color Highlighter - Show colors inline
    {
        "norcalli/nvim-colorizer.lua",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("colorizer").setup({
                "*",  -- All filetypes
                css = { css = true },  -- Enable CSS functions
                scss = { css = true },
                html = { names = false },  -- Disable names like "red"
            }, {
                RGB = true,      -- #RGB hex codes
                RRGGBB = true,   -- #RRGGBB hex codes
                names = false,   -- "Name" codes like Blue
                RRGGBBAA = true, -- #RRGGBBAA hex codes
                rgb_fn = true,   -- CSS rgb() and rgba() functions
                hsl_fn = true,   -- CSS hsl() and hsla() functions
                css = true,      -- Enable all CSS features
                css_fn = true,   -- Enable all CSS *functions*
                mode = "background",  -- Set the display mode (background/foreground)
            })

            vim.keymap.set("n", "<leader>tc", "<cmd>ColorizerToggle<CR>", { desc = "Toggle Color Highlight" })
        end,
    },

    -- 🌊 Smooth Scrolling
    {
        "karb94/neoscroll.nvim",
        event = "VeryLazy",
        config = function()
            require("neoscroll").setup({
                mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
                hide_cursor = true,
                stop_eof = true,
                respect_scrolloff = false,
                cursor_scrolls_alone = true,
                easing_function = "quadratic",  -- Default easing function
                pre_hook = nil,
                post_hook = nil,
            })
        end,
    },

    -- 🧘 Zen Mode - Distraction-free coding
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        dependencies = {
            "folke/twilight.nvim",  -- Dims inactive code
        },
        config = function()
            require("zen-mode").setup({
                window = {
                    width = 120,
                    options = {
                        number = false,
                        relativenumber = false,
                        signcolumn = "no",
                        cursorline = false,
                    },
                },
                plugins = {
                    twilight = { enabled = true },
                    gitsigns = { enabled = false },
                },
            })

            require("twilight").setup({
                dimming = {
                    alpha = 0.25,
                },
            })

            vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Zen Mode 🧘" })
        end,
    },

    -- 🌈 Indent Rainbow (update existing indent-blankline)
    -- This enhances the existing indent-blankline config in ui.lua

    -- 📬 Beautiful Notifications
    {
        "rcarriga/nvim-notify",
        config = function()
            local notify = require("notify")
            notify.setup({
                stages = "fade_in_slide_out",
                timeout = 3000,
                background_colour = "#000000",
                icons = {
                    ERROR = "",
                    WARN = "",
                    INFO = "",
                    DEBUG = "",
                    TRACE = "✎",
                },
            })

            -- Set as default notification handler
            vim.notify = notify

            -- Keybindings
            vim.keymap.set("n", "<leader>un", function()
                require("notify").dismiss({ silent = true, pending = true })
            end, { desc = "Dismiss Notifications" })

            vim.keymap.set("n", "<leader>uh", "<cmd>Telescope notify<CR>", { desc = "Notification History" })
        end,
    },

    -- 📝 Markdown Enhanced (better rendering in NeoVim)
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("render-markdown").setup({
                enabled = true,
                heading = {
                    enabled = true,
                    sign = true,
                    icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                },
                code = {
                    enabled = true,
                    sign = true,
                    style = "full",
                },
                bullet = {
                    enabled = true,
                    icons = { "●", "○", "◆", "◇" },
                },
            })

            vim.keymap.set("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown Render" })
        end,
    },

    -- 🌐 HTTP Client (simple curl wrapper - no build!)
    {
        "mistweaverco/kulala.nvim",
        ft = "http",
        config = function()
            require("kulala").setup({
                default_view = "body",
                default_env = "dev",
            })

            -- Keybindings for .http files
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "http",
                callback = function()
                    vim.keymap.set("n", "<leader>rr", require("kulala").run, { desc = "Run HTTP Request", buffer = true })
                    vim.keymap.set("n", "<leader>ri", require("kulala").inspect, { desc = "Inspect Request", buffer = true })
                    vim.keymap.set("n", "<leader>rt", require("kulala").toggle_view, { desc = "Toggle View", buffer = true })
                end,
            })
        end,
    },

    -- 🔭 Telescope extension for notifications
    {
        "nvim-telescope/telescope.nvim",
        optional = true,
        dependencies = {
            "rcarriga/nvim-notify",
        },
        config = function()
            require("telescope").load_extension("notify")
        end,
    },
}
