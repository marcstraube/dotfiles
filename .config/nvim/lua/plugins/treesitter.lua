-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                       Treesitter - Syntax Highlighting                   ║
-- ║              AST-based parsing for better highlighting                   ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,  -- Load immediately instead of on event
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        -- Require treesitter configs
        local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
        if not status_ok then
            return  -- Silently return if not available yet
        end

        treesitter.setup({
            -- Install parsers for your languages
            ensure_installed = {
                "php",
                "javascript",
                "typescript",
                "tsx",
                "python",
                "c",
                "sql",
                "css",
                "scss",
                "html",
                "json",
                "yaml",
                "markdown",
                "markdown_inline",
                "bash",
                "lua",
                "vim",
                "vimdoc",
                "regex",
            },

            -- Auto-install missing parsers when entering buffer
            auto_install = true,

            -- Enable highlighting
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            -- Enable indentation
            indent = {
                enable = true,
            },

            -- Incremental selection
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },

            -- Text objects
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>A"] = "@parameter.inner",
                    },
                },
            },
        })
    end,
}
