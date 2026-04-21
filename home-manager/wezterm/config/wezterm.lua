local colors = require("colors")
local wezterm = require("wezterm")
local function tab_title(tab_info)
  local superscript = { "⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹" }

  local function to_superscript(n)
    local result = ""
    for digit in tostring(n):gmatch("%d") do
      result = result .. superscript[tonumber(digit) + 1]
    end
    return result
  end

  local tab_num = to_superscript(tab_info.tab_index + 1)
  local icon = wezterm.nerdfonts.md_console_line
  local title = tab_info.tab_title

  -- Debug output
  wezterm.log_info(
    string.format(
      "[Tab %d] tab_title='%s', pane.title='%s', process='%s', cwd='%s'",
      tab_info.tab_index + 1,
      title or "",
      tab_info.active_pane.title or "",
      tab_info.active_pane.foreground_process_name or "",
      (
        tab_info.active_pane.current_working_dir
        and tab_info.active_pane.current_working_dir.file_path
      ) or ""
    )
  )

  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    wezterm.log_info(string.format("[Tab %d] Using explicit tab_title", tab_info.tab_index + 1))
    return tab_num .. title
  end

  local cwd_uri = tab_info.active_pane.current_working_dir
  local cwd = cwd_uri and cwd_uri.file_path or "~"
  local basename = cwd:match("([^/]+)/?$") or cwd

  -- Get process name
  local process_name = tab_info.active_pane.foreground_process_name
  local process_basename = process_name and process_name:match("([^/\\]+)$") or nil

  local active_pane_title = tab_info.active_pane.title

  -- For other processes (ssh, vim, etc.), use the pane title
  if active_pane_title and #active_pane_title > 0 then
    if active_pane_title:match("OpenCode") then
      icon = wezterm.nerdfonts.oct_dependabot
      -- active_pane_title = active_pane_title:gsub("^OC |%s*", "")
    end

    if active_pane_title:match("^OC |") then
      icon = wezterm.nerdfonts.oct_dependabot
      active_pane_title = active_pane_title:gsub("^OC |%s*", "")
    end

    wezterm.log_info(string.format("[Tab %d] Using active_pane.title", tab_info.tab_index + 1))

    -- Check if title starts with alphanumeric character
    local starts_with_normal = active_pane_title:match("^[A-Za-z0-9]")

    if starts_with_normal then
      return tab_num .. icon .. " " .. active_pane_title
    else
      return tab_num .. " " .. active_pane_title
    end
  end

  -- If running a local shell (zsh, bash, fish, etc.), prefer showing the cwd basename
  if
    process_basename
    and (
      process_basename == "zsh"
      or process_basename == "bash"
      or process_basename == "fish"
      or process_basename == "nu"
    )
  then
    wezterm.log_info(string.format("[Tab %d] Using shell + cwd basename", tab_info.tab_index + 1))
    return tab_num .. icon .. " " .. basename
  end

  wezterm.log_info(string.format("[Tab %d] Using fallback: cwd basename", tab_info.tab_index + 1))
  return tab_num .. icon .. " " .. basename
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = wezterm.truncate_right(tab_title(tab), max_width - 3)

  return {
    { Text = wezterm.nerdfonts.cod_kebab_vertical .. " " .. title .. " " },
  }
end)

local max_fps = 60

return {
  default_prog = {
    "/run/current-system/sw/bin/zsh",
    "-l",
  },

  font = wezterm.font({
    family = "ComicCode Nerd Font",
    -- family = "CaskaydiaCove Nerd Font",
  }),
  font_size = 13,

  initial_cols = 112,
  initial_rows = 28,

  max_fps = max_fps,
  front_end = "WebGpu",
  underline_thickness = "1.5pt",

  -- cursor
  animation_fps = max_fps,
  cursor_blink_ease_in = "EaseOut",
  cursor_blink_ease_out = "EaseOut",
  cursor_blink_rate = 650,
  cursor_thickness = "0.1cell",
  default_cursor_style = "BlinkingUnderline",

  -- color scheme
  colors = colors.scheme,

  -- tab bar
  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  tab_max_width = 24,
  tab_bar_at_bottom = true,
  show_tab_index_in_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  -- switch_to_last_active_tab_when_closing_tab = true,

  -- window
  -- window_decorations = "RESIZE|INTEGRATED_BUTTONS",
  adjust_window_size_when_changing_font_size = false,
  window_close_confirmation = "AlwaysPrompt",
  -- window_background_opacity = colors.opacity,
  -- macos_window_background_blur = 40,
  window_padding = {
    left = "8px",
    right = "8px",
    top = "1cell",
    bottom = 0,
  },
  window_frame = {
    border_left_width = "2px",
    border_right_width = "2px",
    border_left_color = colors.palette.surface1,
    border_right_color = colors.palette.surface1,
  },

  visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 250,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 250,
    target = "CursorColor",
  },

  keys = {
    {
      key = "m",
      mods = "CTRL|SHIFT",
      action = wezterm.action_callback(function(window, pane)
        local tab, pane, window = window:mux_window():spawn_tab({
          args = { "/bin/zsh", "-l", "-c", "nvim '+set wrap ft=markdown'" },
        })
        tab:set_title(wezterm.nerdfonts.fa_edit .. " Quick Note")
      end),
      -- action = wezterm.action.SpawnCommandInNewTab({
      --   args = { "nvim", "+set wrap ft=markdown" },
      -- }),
    },
    {
      key = "LeftArrow",
      mods = "CTRL|SHIFT",
      action = wezterm.action.MoveTabRelative(-1),
    },
    {
      key = "RightArrow",
      mods = "CTRL|SHIFT",
      action = wezterm.action.MoveTabRelative(1),
    },

    -- for line breaking
    { key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
  },

  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "NONE",
      action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
    },
    -- Ctrl-click will open the link under the mouse cursor
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = wezterm.action.OpenLinkAtMouseCursor,
    },
    -- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
    -- {
    --   event = { Down = { streak = 1, button = "Left" } },
    --   mods = "CTRL",
    --   action = wezterm.action.Nop,
    -- },
  },
}
