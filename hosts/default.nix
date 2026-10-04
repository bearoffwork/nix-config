{
  inputs,
  outputs,
  extraModules ? [ ],
  ...
}:

let
  inherit (builtins)
    readDir
    isFunction
    ;

  inherit (inputs.nixpkgs-unstable) lib;

  inherit (lib)
    attrNames
    filter
    filterAttrs
    genAttrs
    pathExists
    ;

  enumerateHosts =
    { basePath }:
    let
      hostDirs = attrNames (filterAttrs (_: type: type == "directory") (readDir basePath));
      hasSystem = name: pathExists (basePath + "/${name}/_system.nix");
      hosts = filter hasSystem hostDirs;
    in
    genAttrs hosts (
      name:
      let
        sysCfg = import (basePath + "/${name}/_system.nix");
        closure = if (isFunction sysCfg) then sysCfg { inherit inputs outputs; } else sysCfg;
        sysBuilder = (closure.nixpkgs or inputs.nixpkgs).lib.nixosSystem;
        modules = closure.modules ++ extraModules;
        systemName = name;
      in
      sysBuilder {
        inherit modules;
        specialArgs = { inherit inputs outputs systemName; };
      }
    );
in
enumerateHosts { basePath = ./.; }
