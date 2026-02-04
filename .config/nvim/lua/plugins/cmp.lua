-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                      Autocompletion with nvim-cmp                        ║
-- ║                    Replaces Deoplete from old config                     ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",     -- LSP completions
        "hrsh7th/cmp-buffer",       -- Buffer completions
        "hrsh7th/cmp-path",         -- Path completions
        "hrsh7th/cmp-cmdline",      -- Cmdline completions
        "saadparwaiz1/cmp_luasnip", -- Snippet completions
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
            dependencies = {
                "rafamadriz/friendly-snippets",  -- Collection of snippets
            },
        },
        "onsails/lspkind.nvim",     -- VS Code-like pictograms
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")

        -- Load friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            mapping = cmp.mapping.preset.insert({
                -- Navigate completion menu
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),

                -- Scroll documentation
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),

                -- Trigger completion
                ["<C-Space>"] = cmp.mapping.complete(),

                -- Close completion
                ["<C-e>"] = cmp.mapping.abort(),

                -- Confirm selection
                ["<CR>"] = cmp.mapping.confirm({ select = false }),

                -- Tab for snippet jumping
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),

            -- Completion sources (order matters for priority)
            sources = cmp.config.sources({
                { name = "nvim_lsp" },  -- LSP
                { name = "luasnip" },   -- Snippets
                { name = "buffer" },    -- Buffer text
                { name = "path" },      -- File paths
            }),

            -- Formatting with lspkind
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = "...",
                    menu = {
                        nvim_lsp = "[LSP]",
                        luasnip = "[Snip]",
                        buffer = "[Buf]",
                        path = "[Path]",
                    },
                }),
            },

            -- Window appearance
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },

            experimental = {
                ghost_text = true,  -- Show preview of completion
            },
        })

        -- Command-line completion for '/'
        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- Command-line completion for ':'
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })
    end,
}
