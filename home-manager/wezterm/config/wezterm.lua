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
  local title = tab_info.tab_title

  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return tab_num .. title
  end

  local active_pane_title = tab_info.active_pane.title
  if active_pane_title and #active_pane_title > 0 then
    return tab_num .. active_pane_title
  end

  local cwd_uri = tab_info.active_pane.current_working_dir
  local cwd = cwd_uri and cwd_uri.file_path or "~"

  local basename = cwd:match("([^/]+)/?$") or cwd

  return tab_num .. " " .. basename
end

-- local function tab_title(tab_info)
--   local title = tab_info.tab_title
--   -- if the tab title is explicitly set, take that
--   if title and #title > 0 then
--     return title
--   end
--   -- Otherwise, use the title from the active pane
--   -- in that tab
--   return tab_info.active_pane.title
-- end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab_title(tab)
  return {
    { Text = " " .. title .. " " },
  }
end)

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

  max_fps = 120,
  front_end = "WebGpu",
  webgpu_power_preference = "HighPerformance",
  -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Dx12', 'IntegratedGpu'),
  -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Gl', 'Other'),
  underline_thickness = "1.5pt",

  -- cursor
  animation_fps = 120,
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
  tab_max_width = 60,
  tab_bar_at_bottom = false,
  show_tab_index_in_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  -- switch_to_last_active_tab_when_closing_tab = true,

  -- window
  window_decorations = "RESIZE|INTEGRATED_BUTTONS",
  adjust_window_size_when_changing_font_size = false,
  window_close_confirmation = "NeverPrompt",
  window_background_opacity = colors.opacity,
  macos_window_background_blur = 40,
  window_padding = {
    left = 8,
    right = 8,
    top = "4px",
    bottom = "4px",
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
      action = wezterm.action.SpawnCommandInNewTab({
        args = { "nvim", "+set wrap ft=markdown" },
      }),
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
    {
      key = "+",
      mods = "CTRL|SHIFT",
      action = wezterm.action.ToggleFullScreen,
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
