-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                            Colorscheme Setup                             ║
-- ║                  Modern themes similar to Spectrum                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
    -- Catppuccin - Modern, vibrant colors (similar to Spectrum)
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,  -- Load first
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",  -- latte, frappe, macchiato, mocha
                transparent_background = false,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    telescope = true,
                    which_key = true,
                    mason = true,
                },
                color_overrides = {
                    mocha = {
                        base = "#252525",  -- Match your Spectrum background
                    },
                },
            })

            -- Set colorscheme
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- Alternative: Tokyo Night
    {
        "folke/tokyonight.nvim",
        enabled = false,  -- Disabled, enable if you want to try it
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "storm",  -- storm, night, moon, day
                transparent = false,
                terminal_colors = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                },
            })
            -- vim.cmd.colorscheme("tokyonight")
        end,
    },

    -- Alternative: Kanagawa
    {
        "rebelot/kanagawa.nvim",
        enabled = false,  -- Disabled, enable if you want to try it
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                transparent = false,
                theme = "wave",  -- wave, dragon, lotus
            })
            -- vim.cmd.colorscheme("kanagawa")
        end,
    },
}
