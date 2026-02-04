-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                   Claude Code CLI Integration                            ║
-- ║              Direct integration with `claude` CLI                        ║
-- ║              Uses your Claude Max account (no API key!)                  ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- This is a custom integration, not an external plugin
-- It loads directly when NeoVim starts

-- ┌──────────────────────────────────────────────────────────────────┐
-- │ Helper Functions                                                 │
-- └──────────────────────────────────────────────────────────────────┘

local M = {}

-- Get visual selection
M.get_visual_selection = function()
    local _, ls, cs = unpack(vim.fn.getpos("v"))
    local _, le, ce = unpack(vim.fn.getpos("."))

    -- Swap if backwards selection
    if ls > le or (ls == le and cs > ce) then
        ls, le = le, ls
        cs, ce = ce, cs
    end

    local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
    if #lines == 0 then return "" end

    -- Handle single line
    if #lines == 1 then
        lines[1] = string.sub(lines[1], cs, ce)
    else
        lines[1] = string.sub(lines[1], cs)
        lines[#lines] = string.sub(lines[#lines], 1, ce)
    end

    return table.concat(lines, "\n")
end

-- Get current buffer content
M.get_buffer_content = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    return table.concat(lines, "\n")
end

-- Get current file path
M.get_current_file = function()
    return vim.fn.expand("%:p")
end

-- Create floating window for output
M.create_float = function(content, title)
    local buf = vim.api.nvim_create_buf(false, true)

    -- Split content into lines
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Window dimensions
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Window options
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = title or "Claude Code",
        title_pos = "center",
    }

    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Buffer options
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    -- Close on q or Esc
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>close<cr>", { noremap = true, silent = true })

    return buf, win
end

-- Execute claude CLI command
M.run_claude = function(prompt, context, mode)
    mode = mode or "ask"  -- ask, refactor, fix, explain

    -- Build command
    local cmd
    if context and context ~= "" then
        -- Escape context for shell
        local escaped_context = context:gsub('"', '\\"')
        local escaped_prompt = prompt:gsub('"', '\\"')

        cmd = string.format('claude "%s\n\nContext:\n```\n%s\n```"', escaped_prompt, escaped_context)
    else
        local escaped_prompt = prompt:gsub('"', '\\"')
        cmd = string.format('claude "%s"', escaped_prompt)
    end

    -- Show loading message
    vim.notify("Claude is thinking...", vim.log.levels.INFO)

    -- Execute command asynchronously
    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                local output = table.concat(data, "\n")
                if output and output ~= "" then
                    vim.schedule(function()
                        M.create_float(output, "Claude Code Response")
                    end)
                end
            end
        end,
        on_stderr = function(_, data)
            if data and #data > 0 then
                local err = table.concat(data, "\n")
                if err ~= "" then
                    vim.schedule(function()
                        vim.notify("Claude Error: " .. err, vim.log.levels.ERROR)
                    end)
                end
            end
        end,
        on_exit = function(_, exit_code)
            if exit_code ~= 0 then
                vim.schedule(function()
                    vim.notify("Claude command failed. Is 'claude' CLI installed?", vim.log.levels.ERROR)
                end)
            end
        end,
    })
end

-- ┌──────────────────────────────────────────────────────────────────┐
-- │ User Commands                                                    │
-- └──────────────────────────────────────────────────────────────────┘

-- Ask Claude (with optional context)
vim.api.nvim_create_user_command("ClaudeAsk", function(opts)
    local prompt = opts.args
    if prompt == "" then
        prompt = vim.fn.input("Ask Claude: ")
    end
    if prompt ~= "" then
        M.run_claude(prompt, nil, "ask")
    end
end, { nargs = "?", desc = "Ask Claude Code" })

-- Ask about selection
vim.api.nvim_create_user_command("ClaudeAskSelection", function(opts)
    local selection = M.get_visual_selection()
    local prompt = opts.args
    if prompt == "" then
        prompt = vim.fn.input("Ask about selection: ")
    end
    if prompt ~= "" then
        M.run_claude(prompt, selection, "ask")
    end
end, { nargs = "?", range = true, desc = "Ask Claude about selection" })

-- Explain selection
vim.api.nvim_create_user_command("ClaudeExplain", function()
    local selection = M.get_visual_selection()
    M.run_claude("Explain this code in detail", selection, "explain")
end, { range = true, desc = "Explain code with Claude" })

-- Refactor selection
vim.api.nvim_create_user_command("ClaudeRefactor", function(opts)
    local selection = M.get_visual_selection()
    local prompt = opts.args
    if prompt == "" then
        prompt = vim.fn.input("Refactor instructions: ")
    end
    if prompt ~= "" then
        M.run_claude("Refactor this code: " .. prompt, selection, "refactor")
    end
end, { nargs = "?", range = true, desc = "Refactor code with Claude" })

-- Fix selection
vim.api.nvim_create_user_command("ClaudeFix", function(opts)
    local selection = M.get_visual_selection()
    local prompt = opts.args
    if prompt == "" then
        prompt = "Fix any bugs or issues in this code"
    end
    M.run_claude(prompt, selection, "fix")
end, { nargs = "?", range = true, desc = "Fix code with Claude" })

-- Ask about current file
vim.api.nvim_create_user_command("ClaudeFile", function(opts)
    local content = M.get_buffer_content()
    local filepath = M.get_current_file()
    local prompt = opts.args
    if prompt == "" then
        prompt = vim.fn.input("Ask about file: ")
    end
    if prompt ~= "" then
        M.run_claude(string.format("%s\n\nFile: %s", prompt, filepath), content, "file")
    end
end, { nargs = "?", desc = "Ask Claude about current file" })

-- ┌──────────────────────────────────────────────────────────────────┐
-- │ Keybindings - Claude Code CLI                                   │
-- │ Prefix: <leader>c (Claude)                                      │
-- └──────────────────────────────────────────────────────────────────┘

local keymap = vim.keymap.set

-- Ask commands
keymap("n", "<leader>ca", "<cmd>ClaudeAsk<cr>", { desc = "Ask Claude (prompt)" })
keymap("v", "<leader>ca", "<cmd>ClaudeAskSelection<cr>", { desc = "Ask Claude about selection" })

-- Quick actions (Visual mode)
keymap("v", "<leader>ce", "<cmd>ClaudeExplain<cr>", { desc = "Claude Explain code" })
keymap("v", "<leader>cr", "<cmd>ClaudeRefactor<cr>", { desc = "Claude Refactor code" })
keymap("v", "<leader>cf", "<cmd>ClaudeFix<cr>", { desc = "Claude Fix code" })

-- File-level
keymap("n", "<leader>cF", "<cmd>ClaudeFile<cr>", { desc = "Claude analyze file" })

-- Return empty table (this file doesn't define a lazy.nvim plugin)
return {}
