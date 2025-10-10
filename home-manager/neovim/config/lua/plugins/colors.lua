---@module "lz.n"
---@type lz.n.PluginSpec[]
return {
    {
        "catppuccin-nvim",
        lazy = false,
        after = function()
            require("catppuccin").setup({
                flavor = "mocha",
                transparent_background = true,
                float = {
                    transparent = true,
                },
                color_overrides = {
                    all = {
                        base = "#0f170f",
                    },
                },
                custom_highlights = function(colors)
                    return {
                        CursorLine = { bg = colors.base },
                        Visual = { bg = colors.surface1 },
                    }
                end,
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    -- {
    --     "tokyonight.nvim",
    --     lazy = false,
    --     after = function()
    --         require("tokyonight").setup({
    --             style = "night",
    --             transparent = true,
    --             styles = {
    --                 sidebars = "transparent",
    --                 floats = "transparent",
    --             },
    --         })
    --         vim.cmd([[colorscheme tokyonight]])
    --     end,
    -- },
}
