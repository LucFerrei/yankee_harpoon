# yankee-harpoon

A Neovim plugin inspired by [harpoon](https://github.com/theprimeagen/harpoon), but for your **yanks** (the primeagen's yankee).

Quickly save, manage, and paste yanked text via a floating menu.

## Features

- Save any yank into a quick-access list (max 5 items)
- Floating menu UI inspired by Harpoon
- Direct paste mappings for instant access
- Session-only (no persistence between Neovim restarts)
- Ignores duplicates

## Requirements

- Neovim >= 0.7.0

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "seu-usuario/yankee-harpoon",
  config = function()
    require("yankee_harpoon").setup()
  end,
}
```

## Configuration

```lua
require("yankee_harpoon").setup({
  max_items = 5,
  menu_width = 60,
  menu_height = 10,
  register = "0", -- last yank register
  save_mapping = "<leader>ya",
  toggle_mapping = "<leader>yh",
  paste_mappings = {
    "<leader>y1",
    "<leader>y2",
    "<leader>y3",
    "<leader>y4",
    "<leader>y5",
  },
  menu_keymaps = {
    close = { "q", "<Esc>" },
    select = "<CR>",
    delete = "d",
    next = "j",
    prev = "k",
  },
})
```

## Usage

1. Yank some text (`y`, `yy`, `yw`, etc.)
2. Press `<leader>ya` to save that yank into the list
3. Press `<leader>yh` to open the menu
4. Navigate with `j`/`k`, press `<CR>` to paste, or `d` to remove an item
5. Alternatively, press `<leader>y1` to `<leader>y5` to paste items directly

## Commands

| Command   | Description                  |
|-----------|------------------------------|
| `:YHAdd`  | Add last yank to the list    |
| `:YHMenu` | Toggle the floating menu     |
| `:YHClear`| Clear the entire list        |

## Menu Keymaps

| Key      | Action                       |
|----------|------------------------------|
| `j` / `k`| Move down / up               |
| `<CR>`   | Paste selected item          |
| `d`      | Delete selected item         |
| `1-5`    | Paste item at index directly |
| `q` / `Esc` | Close menu                |

## License

MIT
