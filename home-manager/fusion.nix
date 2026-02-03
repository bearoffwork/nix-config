# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./cli/direnv.nix
    ./cli/git.nix
    ./cli/sops.nix
    ./cli/zsh
    ./neovim
    ./wezterm
    ./niri
    ./hypr
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # "google-chrome"
    ];

  home = {
    username = "bear";
    homeDirectory = "/home/${config.home.username}";
  };

  xdg.configFile."home-manager" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/p/nix-config";
  };

  home.packages = with pkgs; [
    git
    ripgrep
    fd
    bat
    rsync
    curl
    wget
    watchexec

    wireguard-tools

    xmlstarlet
    just
    htop
    dust
    dig
    viddy
    duckdb
    opencode
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.shellAliases = {
    j = "just";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.bash.enable = true;
  programs.zsh.enable = true;

  programs.chromium = {
    enable = true;
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
