# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  config,
  inputs,
  outputs,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.modules;
in {
  # You can import other home-manager modules here
  imports = [
    outputs.homeManagerModules.presets.direnv
    outputs.homeManagerModules.presets.nix
    outputs.homeManagerModules.presets.git
    outputs.homeManagerModules.presets.zsh
    outputs.homeManagerModules.colima
    outputs.homeManagerModules.awscli

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    ./git.nix
    ./skhd.nix
    ./nvim.nix
  ];

  presets = {
    zsh.promptAtBottom = true;
    zsh.prompt = "starship";
    zsh.starship.transientPrompt = true;
  };

  home.packages = with pkgs; [
    wezterm
    gnumake
    gnused
    rsync
    jq
    bat
    fd
    ripgrep
    just
    android-tools
    stable.colima
  ];

  home.shellAliases = {
    g = "git";
  };

  programs = {
    bash.enable = true;
    zsh.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # home-manager can manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
