{config, ...}: {
  xdg.configFile."hammerspoon" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.xdg.configHome}/home-manager/home-manager/darwin/hammerspoon/config";
  };
}
