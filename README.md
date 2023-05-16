# Golang Documentation inside Neovim

The main ideas:
- offline documentation
- fast (blazingly) search
- use neovim features for searching inside document page


The main goal:
- Add this extension to [this list](https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions)

## How to install
Add the plugin to your favorite package manager
```lua
"blacktrub/telescope-godoc.nvim"
```

Add extension for telescope
```lua
require("telescope").load_extension("godoc")
```

## How to use it
```lua
:Telescope godoc
```
