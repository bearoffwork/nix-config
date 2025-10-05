return {
    {
        "telescope.nvim",
        cmd = "Telescope",
        keys = {
            {
                "<leader>fg",
                function()
                    require("telescope.builtin").live_grep()
                end,
                desc = "Telescope live grep",
            },
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "Telescope find files",
            },
        },
        after = function()
            require("telescope").setup({
                pickers = {
                    find_files = { theme = "ivy" },
                    live_grep = { theme = "ivy" },
                },
            })
            -- Any telescope-specific setup
            -- local builtin = require("telescope.builtin")
            -- Example additional keymaps:
            -- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope find files" })
            -- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        end,
    },
}
