---@module "lz.n"
---@type lz.n.PluginSpec[]
return {
    {
        "diffview.nvim",
        keys = {
            {
                "<leader>fd",
                function()
                    vim.cmd([[DiffviewOpen]])
                end,
            },
        },
        after = function() end,
    },
}
