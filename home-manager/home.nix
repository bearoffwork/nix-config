# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/top-level/all-modules.nix
    ./cli/aws.nix
    ./cli/direnv.nix
    ./cli/git.nix
    ./cli/git-work.nix
    ./cli/sops.nix
    ./cli/zsh
    ./cli/common-utils.nix
    ./darwin
    ./neovim
    ./niri
    ./wezterm
  ];

  nix.package = pkgs.nix;
  nix.settings = {
    trusted-substituters = [
      "s3://nix-cache-073419086835-ap-east-2-an?region=ap-east-2&priority=12"
      "https://cache.nixos.org?priority=64"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydrus@eui.money-1:SnDYeQLMwu1k5DPR2L//f+TN+OnF/U9w3v6Mdm2PG1c="
    ];
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "google-chrome"
      "tart"
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
    opencode
    p.git-graph
    opentofu
    terraform-ls
    tart
    nixos-rebuild
    bruno
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.shellAliases = {
    j = "just";
    gg = "git-graph";
    tf = "tofu";
  };

  # Wayland environment variables for Chromium/Electron apps
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # Additional Wayland variables for better compatibility
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
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
