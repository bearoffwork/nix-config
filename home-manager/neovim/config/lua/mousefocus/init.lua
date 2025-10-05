local MouseFocus = {}
local H = {}

MouseFocus.config = {
    modes = { "n", "i", "v", "t" },
}

function MouseFocus.setup(opts)
    opts = opts or {}

    -- Idiomatic validation using vim.validate
    vim.validate("modes", opts.modes, function(m)
        if m == nil then
            return true
        end
        if type(m) ~= "table" then
            return false
        end
        local valid_modes = {
            n = true,
            i = true,
            v = true,
            t = true,
        }
        for _, mode in ipairs(m) do
            if type(mode) ~= "string" or not valid_modes[mode] then
                return false
            end
        end
        return true
    end, "a table of valid mode strings (n, i, v, t)")

    -- Ensure mouse is enabled
    if not vim.o.mouse:match("a") then
        vim.notify("MouseMove: set mouse=a is required for mousefocus to work", vim.log.levels.WARN)
    end

    vim.o.mousemoveevent = true
    MouseFocus.config = vim.tbl_deep_extend("force", MouseFocus.config, opts)
    MouseFocus.sync_keymap()

    local augroup = vim.api.nvim_create_augroup("Mousefocus", { clear = true })
    vim.api.nvim_create_autocmd("OptionSet", {
        group = augroup,
        pattern = "mousefocus",
        callback = MouseFocus.sync_keymap,
    })
end

H.clear_cache = function()
    H.cache = {
        cur_winid = nil,
    }
end

function MouseFocus.sync_keymap()
    if vim.o.mousefocus then
        vim.keymap.set(MouseFocus.config.modes, "<MouseMove>", function()
            H.clear_cache()
            local mousepos = vim.fn.getmousepos()
            local winid = mousepos.winid
            H.cache.cur_winid = vim.api.nvim_get_current_win()
            if winid > 0 and winid ~= H.cache.cur_winid then
                if vim.api.nvim_win_is_valid(winid) then
                    vim.api.nvim_set_current_win(winid)
                end
            end
        end, { desc = "Mouse focus: switch window on hover" })
    else
        pcall(vim.keymap.del, MouseFocus.config.modes, "<MouseMove>")
        H.clear_cache()
    end
end

return MouseFocus
