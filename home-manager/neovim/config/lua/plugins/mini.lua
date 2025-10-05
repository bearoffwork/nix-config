return {
    "mini.nvim",
    lazy = false,
    priority = 10,
    keys = {
        {
            "<leader>fm",
            function()
                require("mini.files").open()
            end,
            desc = "Open MiniFile",
        },
    },
    after = function()
        require("mini.icons").setup()
        require("mini.misc").setup_auto_root(
            {
                ".git",
                "flake.nix",
                "composer.json",
                "package.json",
                "go.mod",
                "justfile",
            },
            -- fallback: if opening dir use it
            function(path)
                print(path)
                if vim.bo.filetype == "oil" then
                    -- handle if oil.nvim default_file_explorer = true
                    path = require("oil").get_current_dir()
                end
                if vim.fn.isdirectory(path) == 1 then
                    return path
                end
            end
        )
        -- require("mini.misc").setup()
        -- require("mini.hues").setup({
        --     background = "#0c120c",
        --     foreground = "#c0c8cc",
        --     transparent = true,
        --     styles = {
        --         sidebars = "transparent",
        --         floats = "transparent",
        --     },
        --     plugins = {
        --         default = false,
        --         ["nvim-mini/mini.nvim"] = true,
        --     },
        -- })
        require("mini.files").setup( -- No need to copy this inside `setup()`. Will be used automatically.
            {
                -- Customization of shown content
                content = {
                    -- Predicate for which file system entries to show
                    filter = nil,
                    -- What prefix to show to the left of file system entry
                    prefix = nil,
                    -- In which order to show file system entries
                    sort = nil,
                },

                -- Module mappings created only inside explorer.
                -- Use `''` (empty string) to not create one.
                mappings = {
                    close = "q",
                    go_in = "l",
                    go_in_plus = "L",
                    go_out = "h",
                    go_out_plus = "H",
                    mark_goto = "'",
                    mark_set = "m",
                    reset = "<BS>",
                    reveal_cwd = "@",
                    show_help = "g?",
                    synchronize = "=",
                    trim_left = "<",
                    trim_right = ">",
                },

                -- General options
                options = {
                    -- Whether to delete permanently or move into module-specific trash
                    permanent_delete = true,
                    -- Whether to use for editing directories
                    use_as_default_explorer = false,
                },

                -- Customization of explorer windows
                windows = {
                    -- Maximum number of windows to show side by side
                    max_number = math.huge,
                    -- Whether to show preview of file/directory under cursor
                    preview = false,
                    -- Width of focused window
                    width_focus = 50,
                    -- Width of non-focused window
                    width_nofocus = 15,
                    -- Width of preview window
                    width_preview = 25,
                },
            }
        )
    end,
}
