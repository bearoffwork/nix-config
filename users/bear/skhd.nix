{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    skhd
  ];

  home.file."${config.xdg.configHome}/skhd/skhdrc".text = ''
    cmd + ctrl - return       : open -a "Wezterm.app"
    cmd + ctrl - 1            : open -a "Safari.app"
    cmd + ctrl - 2            : open -a "PhpStorm.app"
    cmd + ctrl - 3            : open -a "Visual Studio Code.app"
  '';
}
