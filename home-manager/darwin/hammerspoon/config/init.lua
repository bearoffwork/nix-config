hs.notify
  .new({ title = "Hammerspoon", informativeText = "Config loaded" })
  :withdrawAfter(0.3)
  :send()

hs.window.animationDuration = 0

local function launchApp(appName)
  return function()
    hs.application.launchOrFocus(appName)
  end
end

-- local function bindkey(mods, key, action)
--   hs.hotkey.bind(mods, key, action)
-- end

-- Hotkey Storage
local myHotkeys = {} -- This table holds the key objects so we can toggle them
local function bindkey(mods, key, action)
  -- We use hs.hotkey.new instead of .bind so we have full control,
  -- then we enable it immediately and save it to our table.
  local hk = hs.hotkey.new(mods, key, action):enable()
  table.insert(myHotkeys, hk)
end

local hypr = { "ctrl", "cmd" }
bindkey({ "ctrl", "cmd", "shift" }, "R", function()
  hs.reload()
end)

bindkey(hypr, "return", launchApp("WezTerm"))
bindkey(hypr, "1", launchApp("Microsoft Edge"))
bindkey(hypr, "2", launchApp("LibreChat"))
bindkey(hypr, "3", launchApp("Microsoft Teams (PWA)"))
bindkey(hypr, "4", launchApp("Google Chrome"))
bindkey(hypr, "G", launchApp("Gemini"))

bindkey(hypr, "L", launchApp("LINE"))
bindkey(hypr, "P", launchApp("PhpStorm"))
bindkey(hypr, "T", launchApp("Telegram Web"))

utmFilter = hs.window.filter.new(false):setAppFilter("UTM", { allowRoles = "*" })

utmFilter:subscribe(hs.window.filter.windowFocused, function()
  print("UTM Focused: Disabling Hotkeys")
  for _, hk in ipairs(myHotkeys) do
    hk:disable()
  end
end)

utmFilter:subscribe(hs.window.filter.windowUnfocused, function()
  print("UTM Unfocused: Enabling Hotkeys")
  for _, hk in ipairs(myHotkeys) do
    hk:enable()
  end
end)
