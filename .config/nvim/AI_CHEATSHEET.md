# AI Integration Cheatsheet

## 🎯 Quick Overview

You have **TWO AI systems** working together:

| System | Prefix | Strengths | Setup |
|--------|--------|-----------|-------|
| **Claude Code CLI** | `<leader>a` | Agent features, file ops, uses Claude Max | ✅ Already working (no API key!) |
| **Gemini (codecompanion)** | `<leader>g` | Polished chat UI, streaming, diff mode | Need free API key |

---

## 🔵 Claude Code CLI (`<leader>a`)

**Uses your Claude Max account - no API key needed!**

### Common Workflows

```vim
" Explain code
1. Visual select code (V or v)
2. Press <leader>ae

" Refactor code
1. Visual select code
2. Press <leader>ar
3. Enter refactor instructions

" Fix bugs
1. Visual select buggy code
2. Press <leader>af

" Ask question about file
1. Open file
2. Press <leader>aF
3. Enter question
```

### Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>aa` | Normal | Ask Claude (free-form prompt) |
| `<leader>aa` | Visual | Ask about selected code |
| `<leader>ae` | Visual | Explain code |
| `<leader>ar` | Visual | Refactor code |
| `<leader>af` | Visual | Fix code |
| `<leader>aF` | Normal | Analyze current file |

### How it works

- Spawns `claude` CLI in background
- Shows response in floating window
- Press `q` or `Esc` to close window
- No streaming (waits for full response)

---

## 🟢 Gemini (`<leader>g`)

**Needs free API key from Google**

### Setup (one-time)

```bash
# 1. Get free API key
# Visit: https://makersuite.google.com/app/apikey

# 2. Add to ~/.bashrc or ~/.zshrc
export GEMINI_API_KEY="your-api-key-here"

# 3. Reload shell
source ~/.bashrc  # or ~/.zshrc
```

### Common Workflows

```vim
" Chat with Gemini
<leader>gc  " Opens chat window (toggle)

" Explain code with chat UI
1. Visual select code
2. Press <leader>gc
3. Type question in chat

" Quick actions
1. Visual select code
2. Press <leader>ge (explain)
   or <leader>gr (refactor)
   or <leader>gf (fix)
   or <leader>gt (write tests)

" Actions menu (discover more)
<leader>gp
```

### Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gc` | Normal/Visual | Toggle chat window |
| `<leader>gi` | Normal/Visual | Inline prompt |
| `<leader>ge` | Visual | Explain code |
| `<leader>gr` | Visual | Refactor code |
| `<leader>gf` | Visual | Fix code |
| `<leader>gt` | Visual | Write tests |
| `<leader>gd` | Visual | Add documentation |
| `<leader>gp` | Normal/Visual | Actions menu |

### Features

- **Streaming responses** (see text appear live)
- **Persistent chat** (multi-turn conversations)
- **Diff mode** (preview changes before applying)
- **Polished UI** (dedicated chat buffer)

---

## 💡 When to Use Which?

### Use Claude Code CLI (`<leader>a`) when:
- ✅ You want quick, simple responses
- ✅ Working with your Claude Max account
- ✅ Don't need chat history
- ✅ Want agent-like file operations

### Use Gemini (`<leader>g`) when:
- ✅ You want a chat conversation
- ✅ Need to see response streaming
- ✅ Want to iterate on code changes
- ✅ Prefer polished UI experience

### Pro Tip: Use Both!
```vim
" Ask Gemini for initial refactor ideas (chat UI)
<leader>gc

" Then use Claude for quick fixes
<leader>af
```

---

## 🔧 Commands

### Claude Code CLI
```vim
:ClaudeAsk <question>          " Ask Claude
:ClaudeAskSelection <question> " Ask about selection (visual)
:ClaudeExplain                 " Explain selection (visual)
:ClaudeRefactor <instructions> " Refactor selection (visual)
:ClaudeFix                     " Fix selection (visual)
:ClaudeFile <question>         " Ask about current file
```

### codecompanion (Gemini)
```vim
:CodeCompanionChat Toggle      " Toggle chat
:CodeCompanionChat Add         " Add to chat
:CodeCompanionActions          " Show actions menu
```

---

## 🐛 Troubleshooting

### Claude Code CLI not responding?
```bash
# Check if claude CLI is working
claude --version
claude auth status

# If not authenticated
claude auth login
```

### Gemini not working?
```vim
" Check if API key is set
:echo $GEMINI_API_KEY

" If empty, add to shell config:
" export GEMINI_API_KEY="your-key"
```

### Response window won't close?
```
Press 'q' or 'Esc' in the floating window
```

---

## 🎓 Tips & Tricks

1. **Learn the prefixes**:
   - `<leader>a` = Claude (Agent)
   - `<leader>g` = Gemini

2. **Use which-key**:
   ```
   Press <leader>a and wait → See all Claude commands
   Press <leader>g and wait → See all Gemini commands
   ```

3. **Visual selection shortcuts**:
   ```vim
   vip    " Select paragraph
   vi{    " Select inside braces
   V      " Select line
   ```

4. **Iterate quickly**:
   ```vim
   " Try Gemini refactor
   <leader>gr

   " Not happy? Try Claude
   <leader>ar
   ```

5. **Combine with LSP**:
   ```vim
   gd           " Go to definition
   <leader>ae   " Ask Claude to explain it
   ```

---

**Happy coding with AI! 🚀**

Press `<leader>?` in NeoVim to see ALL keybindings!
