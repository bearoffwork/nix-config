-- Disable built-in SQL ftplugin mappings (sqcomplete.vim in $VIMRUNTIME).
-- Without this, <C-c> in normal mode on sql files inserts a literal "C" character
-- because sql.vim sets up legacy omni-completion maps that intercept the keypress.
vim.g.omni_sql_no_default_maps = 1

vim.o.number = true
vim.o.wrap = false
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.o.mouse = "a"
vim.o.mousefocus = true
vim.o.mousemodel = "extend"

vim.o.undofile = true

vim.o.signcolumn = "yes"

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.timeoutlen = 500

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

vim.o.title = true
vim.o.titlestring = " %t"

vim.o.clipboard = "unnamedplus"

local function paste()
    return {
        vim.fn.split(vim.fn.getreg("\""), "\n"),
        vim.fn.getregtype("\""),
    }
end

vim.g.clipboard = {
    name = "OSC 52",
    copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
        ["+"] = paste,
        ["*"] = paste,
    },
}

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

require("mousefocus").setup()
