vim.opt.packpath:prepend("~/.local/share/nvim-packs")

require("options")
require("keybinds")
require("lz.n").load("plugins")
