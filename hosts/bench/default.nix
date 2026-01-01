{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  networking.hostName = "bench";
  networking.domain = "hope.home";

  wsl.enable = true;
  wsl.defaultUser = "bear";

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
