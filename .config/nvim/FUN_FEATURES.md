# 🎉 Fun & Power Features - Quick Guide

## 🦆 Duck Debugger

Rubber Duck Programming deluxe!

```vim
<leader>dd    " Spawn a duck 🦆
<leader>dk    " Cook the duck 🍗
<leader>da    " Spawn a crab 🦀
```

Multiple ducks supported - spawn as many as you want!

## 🟢 Matrix Rain

Make your code fall like in The Matrix!

```vim
<leader>fml   " Matrix Rain (make_it_rain)
<leader>fms   " Matrix Scramble
<leader>fmg   " Conway's Game of Life
```

Press any key to stop the animation.

## 🎨 Color Highlighter

See colors directly in your code!

```css
background: #FF0000;  /* <- Will be RED! */
color: rgb(0, 255, 0); /* <- Will be GREEN! */
```

```vim
<leader>tc    " Toggle color highlighting
```

Works in: CSS, SCSS, HTML, JavaScript, etc.

## 🌊 Smooth Scrolling

Butter-smooth scrolling animations! Already active on:
- `<C-u>` - Scroll up half page
- `<C-d>` - Scroll down half page
- `<C-b>` - Scroll up full page
- `<C-f>` - Scroll down full page
- `zt`, `zz`, `zb` - Cursor positioning

## 🧘 Zen Mode

Distraction-free coding environment:

```vim
<leader>z     " Toggle Zen Mode
```

Features:
- Hides everything except your code
- Centers the code (120 chars wide)
- Dims inactive code (Twilight)
- Perfect for focus sessions

## 🌈 Indent Rainbow

Indentation levels in different colors!

Already active - just write nested code and see the magic:

```python
def foo():
    if True:        # Red indent line
        for i in range(10):  # Yellow indent line
            print(i)         # Blue indent line
```

## 📬 Beautiful Notifications

macOS-style animated notifications!

```vim
<leader>un    " Dismiss all notifications
<leader>uh    " Show notification history (Telescope)
```

All system messages now look beautiful!

## 📝 Markdown Preview

Live preview Markdown in your browser:

```vim
<leader>mp    " Toggle Markdown Preview
```

Open any `.md` file and press `<leader>mp` - browser opens with live preview!

## 🌐 REST Client

Test HTTP APIs directly in NeoVim (like Postman)!

**Usage:**
1. Create a `.http` file:
   ```http
   GET https://api.github.com/users/github
   ```

2. Put cursor on the request

3. Press `<leader>rr` to run it!

**More commands:**
```vim
<leader>rr    " Run request under cursor
<leader>rp    " Preview request
<leader>rl    " Run last request
```

**Example file:** `~/.config/nvim/rest-example.http`

Open it with:
```bash
nvim ~/.config/nvim/rest-example.http
```

## 🎯 Pro Tips

**Combine features:**
```vim
" Zen Mode + Matrix Rain = Epic coding session!
<leader>z     " Enter Zen Mode
<leader>fml   " Start Matrix Rain
" Code like Neo 😎
```

**Duck spam:**
```vim
" Spawn 10 ducks for maximum chaos!
<leader>dd
<leader>dd
<leader>dd
...
```

**Productivity boost:**
```vim
<leader>z     " Zen Mode for focus
<leader>mp    " Markdown preview for docs
<leader>rr    " Test APIs
```

## 🐛 Troubleshooting

**Markdown Preview not opening?**
- Run `:call mkdp#util#install()` once

**REST Client not working?**
- Make sure file ends with `.http`
- Check if `curl` is installed

**Colors not showing?**
- Press `<leader>tc` to toggle colorizer

**Duck not appearing?**
- Wait a second, he's shy 🦆

---

**Have fun! 🎉**

Press `<leader>?` to see all available keybindings!
