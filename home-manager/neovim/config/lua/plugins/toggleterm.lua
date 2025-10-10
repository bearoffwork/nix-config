---@module "lz.n"
---@type lz.n.PluginSpec[]
return {
    {
        "toggleterm.nvim",
        cmd = "ToggleTerm",
        keys = {
            {
                "<Esc>",
                function()
                    if vim.bo.filetype == "toggleterm" then
                        require("toggleterm").toggle()
                    end
                end,
                -- function()
                --     require("toggleterm").toggle()
                -- end,
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
            require("toggleterm").setup()
        end,
    },
}
