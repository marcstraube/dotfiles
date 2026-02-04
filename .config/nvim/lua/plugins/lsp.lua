-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                    LSP Configuration with Mason                          ║
-- ║         Using native vim.lsp.config (NeoVim 0.11+)                       ║
-- ║    Languages: PHP, JS/TS, Python, C, SQL, CSS/SCSS                      ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
    -- Mason: LSP installer
    {
        "williamboman/mason.nvim",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local mason = require("mason")
            mason.setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            -- ┌──────────────────────────────────────────────────────────────┐
            -- │ Auto-install LSP Servers                                     │
            -- └──────────────────────────────────────────────────────────────┘
            local servers_to_install = {
                "lua-language-server",
                "intelephense",
                "typescript-language-server",
                "pyright",
                "clangd",
                "sqlls",
                "css-lsp",
                "html-lsp",
                "json-lsp",
            }

            -- Auto-install missing servers (silently)
            local registry = require("mason-registry")
            registry.refresh(function()
                for _, server_name in ipairs(servers_to_install) do
                    local package = registry.get_package(server_name)
                    if not package:is_installed() then
                        package:install()  -- Install silently
                    end
                end
            end)


            -- Get capabilities for autocompletion
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- ┌──────────────────────────────────────────────────────────────┐
            -- │ Diagnostic Configuration                                     │
            -- └──────────────────────────────────────────────────────────────┘
            vim.diagnostic.config({
                virtual_text = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.HINT] = "󰠠 ",
                        [vim.diagnostic.severity.INFO] = " ",
                    },
                },
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = "always",
                },
            })

            -- ┌──────────────────────────────────────────────────────────────┐
            -- │ LSP Keybindings (attached when LSP starts)                  │
            -- └──────────────────────────────────────────────────────────────┘
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }
                    local keymap = vim.keymap.set

                    -- Navigation
                    keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                    keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
                    keymap("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
                    keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
                    keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))

                    -- Actions
                    keymap("n", "<leader>la", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
                    keymap("n", "<leader>lr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
                    keymap("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format document" }))

                    -- Diagnostics
                    keymap("n", "<leader>ld", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show line diagnostics" }))
                    keymap("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
                    keymap("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
                    keymap("n", "<leader>lq", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostics to loclist" }))

                    -- Workspace
                    keymap("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
                    keymap("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
                end,
            })

            -- ┌──────────────────────────────────────────────────────────────┐
            -- │ Native NeoVim 0.11+ LSP Setup                                │
            -- └──────────────────────────────────────────────────────────────┘

            -- Helper function to check if LSP server binary exists
            local function server_exists(name)
                return vim.fn.exepath(name) ~= ""
            end

            -- Lua Language Server
            if server_exists("lua-language-server") then
                vim.lsp.config("lua_ls", {
                    cmd = { "lua-language-server" },
                    filetypes = { "lua" },
                    root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        },
                    },
                })
            end

            -- PHP (Intelephense)
            if server_exists("intelephense") then
                vim.lsp.config("intelephense", {
                    cmd = { "intelephense", "--stdio" },
                    filetypes = { "php" },
                    root_markers = { "composer.json", ".git" },
                    capabilities = capabilities,
                })
            end

            -- TypeScript/JavaScript
            if server_exists("typescript-language-server") then
                vim.lsp.config("ts_ls", {
                    cmd = { "typescript-language-server", "--stdio" },
                    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
                    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
                    capabilities = capabilities,
                })
            end

            -- Python (Pyright)
            if server_exists("pyright-langserver") then
                vim.lsp.config("pyright", {
                    cmd = { "pyright-langserver", "--stdio" },
                    filetypes = { "python" },
                    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
                    capabilities = capabilities,
                })
            end

            -- C/C++ (clangd)
            if server_exists("clangd") then
                vim.lsp.config("clangd", {
                    cmd = { "clangd" },
                    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                    root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" },
                    capabilities = capabilities,
                })
            end

            -- SQL
            if server_exists("sql-language-server") then
                vim.lsp.config("sqlls", {
                    cmd = { "sql-language-server", "up", "--method", "stdio" },
                    filetypes = { "sql", "mysql" },
                    root_markers = { ".git" },
                    capabilities = capabilities,
                })
            end

            -- CSS
            if server_exists("vscode-css-language-server") then
                vim.lsp.config("cssls", {
                    cmd = { "vscode-css-language-server", "--stdio" },
                    filetypes = { "css", "scss", "less" },
                    root_markers = { "package.json", ".git" },
                    capabilities = capabilities,
                })
            end

            -- HTML
            if server_exists("vscode-html-language-server") then
                vim.lsp.config("html", {
                    cmd = { "vscode-html-language-server", "--stdio" },
                    filetypes = { "html" },
                    root_markers = { "package.json", ".git" },
                    capabilities = capabilities,
                })
            end

            -- JSON
            if server_exists("vscode-json-language-server") then
                vim.lsp.config("jsonls", {
                    cmd = { "vscode-json-language-server", "--stdio" },
                    filetypes = { "json", "jsonc" },
                    root_markers = { "package.json", ".git" },
                    capabilities = capabilities,
                })
            end

            -- Collect enabled servers
            local enabled_servers = {}
            local server_checks = {
                { name = "lua_ls", bin = "lua-language-server" },
                { name = "intelephense", bin = "intelephense" },
                { name = "ts_ls", bin = "typescript-language-server" },
                { name = "pyright", bin = "pyright-langserver" },
                { name = "clangd", bin = "clangd" },
                { name = "sqlls", bin = "sql-language-server" },
                { name = "cssls", bin = "vscode-css-language-server" },
                { name = "html", bin = "vscode-html-language-server" },
                { name = "jsonls", bin = "vscode-json-language-server" },
            }

            for _, server in ipairs(server_checks) do
                if server_exists(server.bin) then
                    table.insert(enabled_servers, server.name)
                end
            end

            -- Enable all configured servers
            if #enabled_servers > 0 then
                vim.lsp.enable(enabled_servers)
            end
        end,
    },
}
