{
  inputs,
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
  wsl.useWindowsDriver = true;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    let
      name = lib.getName pkg;
    in
    lib.hasPrefix "cudatoolkit" name
    || lib.hasPrefix "cuda-merged" name
    || lib.hasPrefix "cudnn" name
    || lib.hasPrefix "nvidia-x11" name
    || lib.hasPrefix "nvidia" name
    || lib.hasPrefix "libcublas" name
    || lib.hasPrefix "libcudnn" name
    || lib.hasPrefix "libcufft" name
    || lib.hasPrefix "libcufile" name
    || lib.hasPrefix "libcurand" name
    || lib.hasPrefix "libcusolver" name
    || lib.hasPrefix "libcusparse" name
    || lib.hasPrefix "libcutensor" name
    || lib.hasPrefix "libnpp" name
    || lib.hasPrefix "libnvjitlink" name
    || lib.hasPrefix "libnvjpeg" name
    || lib.hasPrefix "libnvidia" name;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
