{config, ...}: {
  xdg.configFile."wezterm" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/src/p/nix-config/home-manager/wezterm/config";
  };
  home.sessionVariables = {
    WEZTERM_CONFIG_FILE = "${config.xdg.configHome}/wezterm/wezterm.lua";
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
  };
}
