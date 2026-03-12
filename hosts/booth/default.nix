{
  inputs,
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./lima-guest.nix
    ./users.nix
  ];

  system.stateVersion = "25.11";
}
