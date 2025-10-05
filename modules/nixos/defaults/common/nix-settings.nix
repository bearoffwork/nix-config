{
  inputs,
  config,
  lib,
  ...
}: {
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = lib.mkDefault "nix-command flakes";
      flake-registry = lib.mkDefault "";
      nix-path = lib.mkDefault config.nix.nixPath;
      trusted-users = lib.mkDefault config.defaults.trustedUsers;
    };
    channel.enable = lib.mkDefault false;

    registry = lib.mkDefault (lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs);
    nixPath = lib.mkDefault (lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs);
  };
}
