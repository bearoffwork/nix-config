---@module "lz.n"
---@type lz.n.PluginSpec[]
return {
    {
        "render-markdown.nvim",
        ft = { "markdown" },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        after = function()
            vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#2a2a3a" })

            require("render-markdown").setup({
                preset = "obsidian",
                code = {
                    border = "thin",
                },
            })
        end,
        -- opts = {},
    },
}
