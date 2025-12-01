{
  inputs,
  outputs,
  self,
  ...
}: let
  nixos-raspberrypi = inputs.nixos-raspberrypi;
in {
  mkRpiSystem = name: {
    "${name}" = nixos-raspberrypi.lib.nixosSystemFull {
      specialArgs = {
        inherit inputs outputs nixos-raspberrypi;
        sysname = name;
      };
      modules = [
        "${self}/hosts/${name}"
      ];
    };
  };

  # listModulesRecursive = let
  #   scan = dir:
  #     if builtins.pathExists (dir + "/default.nix")
  #     then [(dir + "/default.nix")]
  #     else
  #       (
  #         lib.mapAttrsToList
  #         (
  #           name: type:
  #             if type == "directory"
  #             then scan (dir + "/${name}")
  #             else dir + "/${name}"
  #         )
  #         (builtins.readDir dir)
  #       );
  # in
  #   dir: lib.flatten (scan dir);
}
