{ config, ... }:
{
  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/p/nix-config/home-manager/niri/config";
  };
}
