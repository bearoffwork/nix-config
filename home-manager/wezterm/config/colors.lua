local wezterm = require("wezterm")

local M = {}

local opacity = 0.75
local catppuccin = {
  rosewater = wezterm.color.parse("#f4dbd6"),
  flamingo = wezterm.color.parse("#f0c6c6"),
  pink = wezterm.color.parse("#f5bde6"),
  mauve = wezterm.color.parse("#c6a0f6"),
  red = wezterm.color.parse("#ed8796"),
  maroon = wezterm.color.parse("#ee99a0"),
  peach = wezterm.color.parse("#f5a97f"),
  yellow = wezterm.color.parse("#eed49f"),
  green = wezterm.color.parse("#a6da95"),
  teal = wezterm.color.parse("#8bd5ca"),
  sky = wezterm.color.parse("#91d7e3"),
  sapphire = wezterm.color.parse("#7dc4e4"),
  blue = wezterm.color.parse("#8aadf4"),
  lavender = wezterm.color.parse("#b7bdf8"),
  text = wezterm.color.parse("#cad3f5"),
  subtext1 = wezterm.color.parse("#b8c0e0"),
  subtext0 = wezterm.color.parse("#a5adcb"),
  overlay2 = wezterm.color.parse("#939ab7"),
  overlay1 = wezterm.color.parse("#8087a2"),
  overlay0 = wezterm.color.parse("#6e738d"),
  surface2 = wezterm.color.parse("#0f170f"):lighten(0.5):desaturate(0.7),
  surface1 = wezterm.color.parse("#0f170f"):lighten(0.12):desaturate(0.3),
  surface0 = wezterm.color.parse("#0f170f"):darken(0.1):desaturate(0.3),
  base = wezterm.color.parse("#0f170f"),
  mantle = wezterm.color.parse("#1e2030"),
  crust = wezterm.color.parse("#181926"),
}

M.palette = catppuccin
M.opacity = opacity
M.c = wezterm.color
M.c.with_alpha = function(color, alpha)
  local h, s, l = color:hsla()
  return wezterm.color.from_hsla(h, s, l, alpha)
end

M.scheme = {
  foreground = catppuccin.text,
  background = catppuccin.base,
  cursor_bg = catppuccin.rosewater,
  cursor_border = catppuccin.rosewater,
  cursor_fg = catppuccin.crust,
  selection_bg = catppuccin.surface1,
  selection_fg = catppuccin.text,
  ansi = {
    catppuccin.surface1, -- black
    catppuccin.red:darken(0.1), -- red
    catppuccin.green:darken(0.3), -- green
    catppuccin.yellow, -- yellow
    catppuccin.blue, -- blue
    catppuccin.mauve, -- magenta/purple
    catppuccin.teal, -- cyan
    catppuccin.subtext1:lighten(0.5), -- white
  },
  brights = {
    catppuccin.surface2, -- bright black
    catppuccin.maroon, -- bright red
    catppuccin.green, -- bright green (could use teal for variation)
    catppuccin.peach, -- bright yellow (could use peach)
    catppuccin.sapphire, -- bright blue
    catppuccin.pink, -- bright magenta
    catppuccin.sky, -- bright cyan
    catppuccin.text, -- bright white
  },
  -- window_frame = {
  --   active_titlebar_bg = mocha.base,
  -- },
  tab_bar = {
    background = M.c.with_alpha(catppuccin.base, opacity),
    active_tab = {
      bg_color = M.c.with_alpha(catppuccin.base, opacity):saturate(0.3):lighten_fixed(0.05),
      fg_color = catppuccin.peach,
    },
    inactive_tab = {
      bg_color = M.c.with_alpha(catppuccin.base, opacity):lighten_fixed(0.05),
      fg_color = catppuccin.teal,
    },
    inactive_tab_hover = {
      bg_color = M.c.with_alpha(catppuccin.base, opacity):lighten_fixed(0.08),
      fg_color = catppuccin.teal,
    },
    new_tab = {
      bg_color = catppuccin.base,
      fg_color = catppuccin.base,
    },
    new_tab_hover = {
      bg_color = catppuccin.base,
      fg_color = catppuccin.base,
      italic = true,
    },
  },
  visual_bell = catppuccin.red,
  indexed = {
    [16] = catppuccin.peach,
    [17] = catppuccin.rosewater,
  },
  scrollbar_thumb = catppuccin.surface2,
  split = catppuccin.overlay0,
  compose_cursor = catppuccin.flamingo,
}

return M
