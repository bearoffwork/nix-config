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

local function bindkey(mods, key, action)
  hs.hotkey.bind(mods, key, action)
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

bindkey(hypr, "L", launchApp("LINE"))
bindkey(hypr, "P", launchApp("PhpStorm"))
bindkey(hypr, "T", launchApp("Telegram Web"))
