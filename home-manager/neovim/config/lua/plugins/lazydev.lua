---@module "lz.n"
---@type lz.n.PluginSpec[]
return {
    {
        "lazydev.nvim",
        ft = "lua",
        after = function()
            require("lazydev").setup({
                library = {
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                },
            })
        end,
    },
}
