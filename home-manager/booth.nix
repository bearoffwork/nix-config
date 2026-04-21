# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/top-level/all-modules.nix
    ./cli/direnv.nix
    ./cli/git-booth.nix
    ./cli/sops.nix
    ./cli/zsh
    ./neovim
  ];

  home = {
    username = "bear";
    homeDirectory = "/home/${config.home.username}";
    srcDirectory = "/Users/${config.home.username}/src";
  };

  xdg.configFile."home-manager" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.srcDirectory}/p/nix-config";
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
    just
    htop
    dust
    dig
    viddy
    duckdb
    opencode
    awscli2
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.shellAliases = {
    j = "just";
  };

  programs.direnv.stdlib = ''
    source /Users/bear/.config/lima-booth/direnv/direnvrc
  '';

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
