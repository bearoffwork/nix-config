{lib, ...}: let
in {
  imports = [
    ./nix-settings.nix
    ./network.nix
    ./packages.nix
  ];

  usual.trustedUsers = lib.mkDefault ["bear"];
}
