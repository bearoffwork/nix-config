{ ... }:
{
  imports = [
    ./modules/zsh
  ];

  home = {
    username = "bear";
    homeDirectory = "/home/bear";
  };

  programs.home-manager.enable = true;
  programs.zsh.enable = true;

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
