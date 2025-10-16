vim.keymap.set("n", "<leader>yc", function()
    local filename = vim.fn.expand("%")
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = "# " .. filename .. "\n" .. table.concat(lines, "\n")
    vim.fn.setreg("+", content)

    -- Highlight entire buffer explicitly
    local line_count = vim.api.nvim_buf_line_count(0)
    vim.highlight.range(
        0,
        vim.api.nvim_create_namespace("yank_highlight"),
        "IncSearch",
        { 0, 0 },
        { line_count - 1, -1 }
    )

    -- Clear highlight after delay
    vim.defer_fn(function()
        vim.api.nvim_buf_clear_namespace(0, vim.api.nvim_create_namespace("yank_highlight"), 0, -1)
    end, 150)

    print("Yanked file with header to clipboard")
end, { desc = "Yank file with header" })
