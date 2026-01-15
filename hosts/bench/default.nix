{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./docker.nix
    ./users.nix
    ./nvidia.nix
  ];

  networking.hostName = "bench";
  networking.domain = "hope.home";

  wsl.enable = true;
  wsl.defaultUser = "bear";
  # wsl.useWindowsDriver = true;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    lib.hasPrefix "cudatoolkit" (lib.getName pkg)
    || lib.hasPrefix "cuda-merged" (lib.getName pkg)
    || lib.hasPrefix "cudnn" (lib.getName pkg)
    || lib.hasPrefix "nvidia-x11" (lib.getName pkg)
    || lib.hasPrefix "nvidia" (lib.getName pkg);

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
