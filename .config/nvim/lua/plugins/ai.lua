-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                   AI Integration - codecompanion.nvim                    ║
-- ║                      Using Gemini Free API                               ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
        {
            "stevearc/dressing.nvim",
            opts = {},
        },
    },
    config = function()
        require("codecompanion").setup({
            -- Configure AI adapters
            adapters = {
                gemini = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        -- Set your Gemini API key as environment variable: GEMINI_API_KEY
                        -- Get free API key at: https://makersuite.google.com/app/apikey
                    })
                end,
                -- Anthropic adapter available but optional (requires separate API key)
                anthropic = function()
                    return require("codecompanion.adapters").extend("anthropic", {
                        -- Only needed if you want to use Anthropic API
                        -- (separate from Claude Max account)
                    })
                end,
            },

            -- Default to Gemini (free API)
            strategies = {
                chat = {
                    adapter = "gemini",
                },
                inline = {
                    adapter = "gemini",
                },
            },

            -- Display settings
            display = {
                chat = {
                    window = {
                        layout = "vertical",  -- vertical, horizontal, float
                        width = 0.45,
                        height = 0.8,
                    },
                },
                diff = {
                    provider = "mini_diff",
                },
            },

            -- Inline assistance
            opts = {
                send_code = true,
                use_default_actions = true,
            },
        })

        -- ┌──────────────────────────────────────────────────────────────────┐
        -- │ Keybindings - codecompanion (Gemini)                            │
        -- │ Prefix: <leader>m (Model/Gemini)                                │
        -- └──────────────────────────────────────────────────────────────────┘
        local keymap = vim.keymap.set

        -- Open chat
        keymap("n", "<leader>mc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Gemini Chat (Toggle)" })
        keymap("v", "<leader>mc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Gemini Chat with selection" })

        -- Inline actions
        keymap("n", "<leader>mi", "<cmd>CodeCompanionChat Add<cr>", { desc = "Gemini Inline prompt" })
        keymap("v", "<leader>mi", "<cmd>CodeCompanionChat Add<cr>", { desc = "Gemini Inline with selection" })

        -- Quick actions (Visual mode)
        keymap("v", "<leader>me", "<cmd>CodeCompanionChat Add<cr>", { desc = "Gemini Explain code" })
        keymap("v", "<leader>mr", "<cmd>CodeCompanionChat Add<cr>", { desc = "Gemini Refactor code" })
        keymap("v", "<leader>mf", "<cmd>CodeCompanionChat Add<cr>", { desc = "Gemini Fix code" })
        keymap("v", "<leader>mt", "<cmd>CodeCompanionChat Add<cr>", { desc = "Gemini Write tests" })
        keymap("v", "<leader>md", "<cmd>CodeCompanionChat Add<cr>", { desc = "Gemini Add docs" })

        -- Actions menu
        keymap({ "n", "v" }, "<leader>mp", "<cmd>CodeCompanionActions<cr>", { desc = "Gemini Actions (menu)" })
    end,
}

-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                            Setup Instructions                            ║
-- ╚══════════════════════════════════════════════════════════════════════════╝
--
-- For Gemini (FREE):
--   1. Get API key: https://makersuite.google.com/app/apikey
--   2. Set environment variable:
--      export GEMINI_API_KEY="your-api-key-here"
--   3. Add to ~/.bashrc or ~/.zshrc
--
-- Usage:
-- - <leader>gc: Open Gemini chat
-- - Visual select code + <leader>ge: Explain selected code
-- - Visual select code + <leader>gr: Refactor selected code
-- - <leader>gp: Open Gemini actions menu
--
-- Note: For Claude Code CLI integration, see claude-cli.lua
-- Use <leader>a prefix for Claude Code commands
--
