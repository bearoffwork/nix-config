{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./usual.nix
    ./docker.nix
    ./users.nix
    # ./nvidia.nix
    # outputs.nixosModules.usual.default
  ];

  networking.hostName = "bench";
  networking.domain = "hope.home";

  wsl.enable = true;
  wsl.defaultUser = "bear";
  # wsl.useWindowsDriver = true;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
