vim.o.number = true
vim.o.wrap = false
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.clipboard = "unnamedplus"

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

-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

require("mousefocus").setup()
