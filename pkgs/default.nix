# SPDX-License-Identifier: MIT

lib: pkgs:

let
  inherit (builtins) readDir;
  inherit (lib)
    attrNames
    filterAttrs
    listToAttrs
    pathExists
    ;

  enumeratePackages =
    basePath:
    let
      # Get all directories in by-name
      packageDirs = attrNames (filterAttrs (_: type: type == "directory") (readDir basePath));

      # Build path to package.nix for each package
      mkPackagePath = package: basePath + "/${package}/package.nix";

      # Filter to only packages that have package.nix
      validPackagePaths = builtins.filter pathExists (map mkPackagePath packageDirs);
    in
    validPackagePaths;

  mkUnitPackage = pkgs: path: {
    name = baseNameOf (dirOf path);
    value = pkgs.callPackage path { };
  };
in
listToAttrs (map (mkUnitPackage pkgs) (enumeratePackages ../by-name))
