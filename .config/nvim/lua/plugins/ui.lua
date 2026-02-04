-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          UI Enhancements                                 ║
-- ║         Statusline, bufferline, which-key, and more                      ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
    -- Lualine: Statusline (replaces vim-airline)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",  -- Auto-detect from colorscheme
                    component_separators = { left = "|", right = "|" },
                    section_separators = { left = "", right = "" },
                    globalstatus = true,  -- One statusline for all windows
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- Bufferline: Buffer tabs at the top
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    separator_style = "slant",
                    always_show_bufferline = true,
                    show_buffer_close_icons = true,
                    show_close_icon = false,
                    diagnostics = "nvim_lsp",
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            text_align = "center",
                            separator = true,
                        },
                    },
                },
            })
        end,
    },

    -- Which-key: Show available keybindings (THIS IS THE HELP COMMAND!)
    {
        "folke/which-key.nvim",
        lazy = false,  -- Load immediately for reliable popup
        config = function()
            local wk = require("which-key")

            wk.setup({
                preset = "modern",
                delay = 300,  -- Time in ms to show the popup
                win = {
                    border = "rounded",
                },
                icons = {
                    rules = false,
                },
                triggers = {
                    { "<leader>", mode = { "n", "v" } },
                },
            })

            -- Register key groups with descriptions
            wk.add({
                { "<leader>f", group = "Find (Telescope)" },
                { "<leader>fm", group = "Fun/Matrix 🟢" },
                { "<leader>l", group = "LSP" },
                { "<leader>g", group = "Git" },
                { "<leader>c", group = "Claude AI" },
                { "<leader>m", group = "Gemini/Markdown" },
                { "<leader>e", group = "Explorer" },
                { "<leader>b", group = "Buffer" },
                { "<leader>s", group = "Split" },
                { "<leader>t", group = "Tab/Terminal/Toggle" },
                { "<leader>h", group = "Dashboard/Git Hunk" },
                { "<leader>x", group = "Trouble" },
                { "<leader>d", group = "Duck 🦆" },
                { "<leader>r", group = "REST Client" },
                { "<leader>u", group = "UI/Notifications" },
                { "<leader>z", desc = "Zen Mode 🧘" },
            })

            -- Keybinding to show all keymaps
            vim.keymap.set("n", "<leader>?", "<cmd>WhichKey<CR>", { desc = "Show all keybindings" })
        end,
    },

    -- Indent-blankline: Indentation guides with Rainbow colors 🌈
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            -- Define rainbow highlight groups
            local highlight = {
                "RainbowRed",
                "RainbowYellow",
                "RainbowBlue",
                "RainbowOrange",
                "RainbowGreen",
                "RainbowViolet",
                "RainbowCyan",
            }

            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
                vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
                vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
                vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)

            require("ibl").setup({
                indent = {
                    char = "│",
                    highlight = highlight,
                },
                scope = {
                    enabled = true,
                    show_start = true,
                    show_end = false,
                    highlight = highlight,
                },
            })
        end,
    },

    -- Dressing: Better UI for inputs and selects
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        config = function()
            require("dressing").setup({
                input = {
                    border = "rounded",
                },
                select = {
                    border = "rounded",
                    backend = { "telescope", "builtin" },
                },
            })
        end,
    },

    -- Noice: Modern UI for messages, cmdline, popupmenu (OPTIONAL - can be heavy)
    {
        "folke/noice.nvim",
        enabled = false,  -- Disabled by default, enable if you want fancy UI
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                presets = {
                    bottom_search = true,
                    command_palette = true,
                    long_message_to_split = true,
                },
            })
        end,
    },
}
