{
  inputs,
  config,
  lib,
  ...
}:
{
  options.usual.trustedUsers = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "List of trusted Nix users";
  };

  config.nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = lib.mkDefault "nix-command flakes";
        # flake-registry = lib.mkDefault "";
        nix-path = lib.mkDefault config.nix.nixPath;
        trusted-users = lib.mkDefault config.usual.trustedUsers;
      };
      channel.enable = lib.mkDefault false;
      registry = lib.mkDefault (lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs);
      nixPath = lib.mkDefault (lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs);
    };
}
