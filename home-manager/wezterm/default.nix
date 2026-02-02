{ config, pkgs, ... }:
{
  xdg.configFile."wezterm" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/p/nix-config/home-manager/wezterm/config";
  };
  home.sessionVariables = {
    WEZTERM_CONFIG_FILE = "${config.xdg.configHome}/wezterm/wezterm.lua";
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.symlinkJoin {
      name = "wezterm-x11";
      paths = [ pkgs.wezterm ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/wezterm \
          --unset WAYLAND_DISPLAY
      '';
    };
  };
}
