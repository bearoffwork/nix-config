{ lib, ... }:
let
in
{
  _module.args = {
    fn = import ../../fn.nix { inherit lib; };
  };

  imports = [
    ./nix-settings.nix
    ./network.nix
    ./packages.nix
  ];

  usual.trustedUsers = lib.mkDefault [ "bear" ];
}
