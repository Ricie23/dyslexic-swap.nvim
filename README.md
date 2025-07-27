# nvim-dyslexic-swap

<p align="center">
  <img src="https://raw.githubusercontent.com/Ricie23/nvim-dyslexic-swap/main/swap-letters.gif" alt="Swap Demo" width="600"/>
</p>

A tiny Neovim plugin to quickly swap two letters around the cursor — especially helpful for correcting common dyslexic typing errors.

## ✨ Features

- Swap the two letters around the cursor in **normal** or **insert** mode.
- Configurable keybindings.
- Minimal and fast — ideal for a lightweight workflow.
  Default keybindings:
  ```
    normal_mode = " z, "
    insert_mode = " <C-x> "
  ```

  ### Available Options
  -Change the keymappings for both Insert and Normal Mode
  -Disable Insert or Normal mode by setting **false**
  
```lua
  opts = {
    insert_mode = false
    normal_mode = "<C-l>"
  }
```
## 🚀 Installation

### Lazy.nvim

Add this to your Lazy plugin spec:

```lua
return {
  {
    "ricie23/nvim-dyslexic-swap",
    lazy = false,
    config = function()
    opts = {}
      require("dyslexic-letter-swap").setup(opts)
    end,
  },
}

```

