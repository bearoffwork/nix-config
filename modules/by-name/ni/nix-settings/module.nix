{
  inputs,
  config,
  lib,
  ...
}:
let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  nix = {
    settings = {
      experimental-features = lib.mkDefault "nix-command flakes";
      # flake-registry = lib.mkDefault "";
      nix-path = lib.mkDefault config.nix.nixPath;
    };
    channel.enable = lib.mkDefault false;
    registry = lib.mkDefault (lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs);
    nixPath = lib.mkDefault (lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs);
  };
}
