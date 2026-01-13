{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./usual.nix
    ./docker.nix
    ./users.nix
    ./nvidia.nix
    # outputs.nixosModules.usual.default
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
    lib.hasPrefix "cuda" name
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
    || lib.hasPrefix "libnvidia" name
    || lib.hasPrefix "nvidia" name;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
