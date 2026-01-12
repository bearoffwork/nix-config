---@module "lz.n"
---@type lz.n.PluginSpec[]
return {
    {
        "render-markdown.nvim",
        ft = { "markdown" },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },
}
