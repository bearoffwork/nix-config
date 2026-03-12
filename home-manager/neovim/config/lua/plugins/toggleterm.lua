---@module "lz.n"
---@type lz.n.PluginSpec[]
return {
    {
        "toggleterm.nvim",
        cmd = "ToggleTerm",
        keys = {
            {
                "<C-c><C-c>",
                function()
                    if vim.bo.filetype == "toggleterm" then
                        require("toggleterm").toggle()
                    end
                end,
                mode = "t",
                desc = "ToggleTerm",
            },
            {
                "<leader>tt",
                function()
                    require("toggleterm").toggle()
                end,
                desc = "ToggleTerm",
            },
        },
        after = function()
            require("toggleterm").setup({})
        end,
    },
}
