---@module "lz.n"
---@type lz.n.PluginSpec[]
return {
    {
        "nvim-lspconfig",
        -- event = "VimEnter",
        lazy = false,
        after = function()
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("nixd")
            vim.lsp.enable("bashls")
            vim.lsp.enable("docker_language_server")
            vim.lsp.enable("docker_compose_language_service")
            vim.lsp.enable("basedpyright")
            vim.lsp.enable("terraformls")

            -- Requires: npm install -g devicetree-language-server
            -- vim.lsp.enable("dtsls")

            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--compile-commands-dir=build",
                },
                -- New way to define root markers (replaces util.root_pattern)
                root_markers = { "west.yml", ".git", "zephyr/module.yml" },
            })
            vim.lsp.enable("clangd")

            vim.diagnostic.config({
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = {
                    severity = vim.diagnostic.severity.ERROR,
                },
                signs = vim.g.have_nerd_font
                        and {
                            text = {
                                [vim.diagnostic.severity.ERROR] = "󰅚 ",
                                [vim.diagnostic.severity.WARN] = "󰀪 ",
                                [vim.diagnostic.severity.INFO] = "󰋽 ",
                                [vim.diagnostic.severity.HINT] = "󰌶 ",
                            },
                        }
                    or {},
                virtual_text = {
                    source = "if_many",
                    spacing = 2,
                    format = function(diagnostic)
                        local bufname = vim.api.nvim_buf_get_name(0)
                        if bufname:match("%.env") and diagnostic.code == "SC2034" then
                            return false
                        end

                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            })
        end,
    },
}
