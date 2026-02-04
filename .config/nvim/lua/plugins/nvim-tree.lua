-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          nvim-tree File Explorer                         ║
-- ║                         Modern NERDTree replacement                      ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",  -- File icons
    },
    config = function()
        require("nvim-tree").setup({
            -- Disable netrw (built-in file explorer)
            disable_netrw = true,
            hijack_netrw = true,

            -- Update focused file in tree
            update_focused_file = {
                enable = true,
                update_root = false,
            },

            -- Git integration
            git = {
                enable = true,
                ignore = false,  -- Show files from .gitignore
            },

            -- Renderer settings
            renderer = {
                root_folder_label = ":~:s?$?/..?",
                highlight_git = true,
                highlight_opened_files = "name",

                icons = {
                    show = {
                        git = true,
                        folder = true,
                        file = true,
                        folder_arrow = true,
                    },
                    glyphs = {
                        default = "",
                        symlink = "",
                        git = {
                            unstaged = "●",
                            staged = "+",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "✭",
                            deleted = "✖",
                            ignored = "◌",
                        },
                        folder = {
                            arrow_open = "",
                            arrow_closed = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                    },
                },
            },

            -- View settings
            view = {
                width = 35,
                side = "left",
            },

            -- Actions
            actions = {
                open_file = {
                    quit_on_open = false,
                    resize_window = true,
                },
            },

            -- Filters
            filters = {
                dotfiles = false,
                custom = { "^.git$" },  -- Hide .git folder
            },
        })

        -- Keybindings
        local keymap = vim.keymap.set
        keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
        keymap("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find current file in tree" })
        keymap("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file tree" })
        keymap("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file tree" })

        -- Auto-close nvim-tree when it's the last window
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
            pattern = "NvimTree_*",
            callback = function()
                local layout = vim.api.nvim_call_function("winlayout", {})
                if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then
                    vim.cmd("quit")
                end
            end,
        })
    end,
}
