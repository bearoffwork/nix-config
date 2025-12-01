---@module "lz.n"
---@type lz.n.PluginSpec[]
return {
    {
        "conform.nvim",
        after = function()
            require("conform").setup({
                -- Map of filetype to formatters
                formatters_by_ft = {
                    lua = { "stylua" },
                    nix = { "alejandra" },
                    sh = { "shfmt" },
                    json = { "jq" },
                    -- -- Conform will run multiple formatters sequentially
                    -- go = { "goimports", "gofmt", "golines" },
                    -- -- You can also customize some of the format options for the filetype
                    -- rust = { "rustfmt", lsp_format = "fallback" },
                    -- You can use a function here to determine the formatters dynamically
                    sql = { "sql_formatter" },
                    -- sql = { "sqlfluff" },
                    python = { "isort", "black" },
                    toml = { "taplo" },
                    -- python = function(bufnr)
                    --     if require("conform").get_formatter_info("ruff_format", bufnr).available then
                    --         return { "ruff_format" }
                    --     else
                    --         return { "isort", "black" }
                    --     end
                    -- end,
                    -- -- Use the "*" filetype to run formatters on all filetypes.
                    ["*"] = { "trim_whitespace" },
                    -- -- Use the "_" filetype to run formatters on filetypes that don't
                    -- -- have other formatters configured.
                },
                formatters = {
                    stylua = {
                        prepend_args = {
                            "--column-width",
                            "100",
                            "--line-endings",
                            "Unix",
                            "--indent-type",
                            "Spaces",
                            "--indent-width",
                            "2",
                            "--quote-style",
                            "ForceDouble",
                            "--call-parentheses",
                            "Always",
                            "--collapse-simple-statement",
                            "Never",
                        },
                    },
                    shfmt = {
                        extra_args = { "-i", "4", "-ci", "-bn" },
                    },
                    -- sqlfluff = {
                    --     args = { "format", "-" },
                    --     stdin = true,
                    -- },
                    sql_formatter = {
                        args = {
                            "-c",
                            vim.json.encode({
                                language = "duckdb",
                                tabWidth = 4,
                                useTabs = false,
                                keywordCase = "upper",
                                linesBetweenQueries = 1,
                                newlineBeforeSemicolon = true,
                                paramTypes = {
                                    positional = true,
                                    numbered = {},
                                    named = {
                                        ":",
                                        "@",
                                        "$", -- duckdb
                                    },
                                },
                            }),
                        },
                        -- stdin = true,
                    },
                },
                -- Set this to change the default values when calling conform.format()
                -- This will also affect the default values for format_on_save/format_after_save
                default_format_opts = {
                    lsp_format = "fallback",
                },
                -- If this is set, Conform will run the formatter on save.
                -- It will pass the table to conform.format().
                -- This can also be a function that returns the table.
                format_on_save = {
                    -- I recommend these options. See :help conform.format for details.
                    lsp_format = "fallback",
                    timeout_ms = 500,
                },
                -- If this is set, Conform will run the formatter asynchronously after save.
                -- It will pass the table to conform.format().
                -- This can also be a function that returns the table.
                format_after_save = {
                    lsp_format = "fallback",
                },
                -- Set the log level. Use `:ConformInfo` to see the location of the log file.
                log_level = vim.log.levels.ERROR,
                -- Conform will notify you when a formatter errors
                notify_on_error = true,
                -- Conform will notify you when no formatters are available for the buffer
                notify_no_formatters = true,
                -- Custom formatters and overrides for built-in formatters
            })
        end,
    },
}
