{ config, ... }:
{
  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/p/nix-config/home-manager/hypr/config";
  };
}
