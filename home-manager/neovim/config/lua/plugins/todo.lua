---@module "lz.n"
---@type lz.n.PluginSpec[]
return {
    {
        "todo-comments.nvim",
        after = function()
            require("todo-comments").setup()
        end,
    },
}
