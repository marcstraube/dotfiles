-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                       Telescope - Fuzzy Finder                           ║
-- ║              Find files, grep, buffers, LSP symbols, etc.                ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",  -- Performance boost
        },
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                path_display = { "smart" },
                file_ignore_patterns = {
                    "node_modules",
                    "vendor",
                    ".git/",
                    "%.jpg",
                    "%.png",
                },

                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    },
                },
            },

            pickers = {
                find_files = {
                    hidden = true,  -- Show hidden files
                },
            },

            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        })

        -- Load extensions
        telescope.load_extension("fzf")

        -- Keybindings
        local keymap = vim.keymap.set
        local builtin = require("telescope.builtin")

        -- File pickers
        keymap("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
        keymap("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
        keymap("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
        keymap("n", "<leader>fw", builtin.grep_string, { desc = "Find word under cursor" })

        -- Buffer pickers
        keymap("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })

        -- Help & Config
        keymap("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
        keymap("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
        keymap("n", "<leader>fc", builtin.commands, { desc = "Find commands" })

        -- Git pickers
        keymap("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
        keymap("n", "<leader>gs", builtin.git_status, { desc = "Git status" })

        -- LSP pickers (will work after LSP is setup)
        keymap("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
        keymap("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
    end,
}
