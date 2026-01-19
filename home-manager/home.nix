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
    ./cli/aws.nix
    ./cli/direnv.nix
    ./cli/git.nix
    ./cli/sops.nix
    ./cli/zsh
    ./darwin
    ./neovim
    ./wezterm
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "google-chrome"
    ];

  home = {
    username = "bear";
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
  };

  xdg.configFile."home-manager" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/p/nix-config";
  };

  home.packages = with pkgs; [
    coreutils
    gnused
    gnumake
    git
    ripgrep
    fd
    bat
    rsync
    curl
    wget
    watchexec

    docker-client
    amazon-ecr-credential-helper
    dive

    wireguard-tools
    # nixos-rebuild

    xmlstarlet
    just
    htop
    nvtopPackages.apple
    llama-cpp
    dust
    dig
    viddy
    duckdb
    claude-code
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

  programs.google-chrome = {
    enable = true;
    package = pkgs.google-chrome;
  };

  systemd.user.startServices = "sd-switch";
  home.stateVersion = "25.05";
}
