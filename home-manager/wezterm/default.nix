{config, ...}: {
  xdg.configFile."wezterm" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/src/p/nix-config/home-manager/wezterm/config";
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
  };
}
