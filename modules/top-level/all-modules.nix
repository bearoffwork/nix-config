{ lib }:

let
  inherit (builtins) readDir;

  inherit (lib)
    attrNames
    filter
    filterAttrs
    pathExists
    ;

  enumerateModules =
    {
      prefix ? "",
      basePath,
    }:
    let
      moduleDirs = attrNames (filterAttrs (_: type: type == "directory") (readDir basePath));
      mkModulePath = name: basePath + "/${name}/${prefix}module.nix";
    in
    filter pathExists (map mkModulePath moduleDirs);

  allModules = enumerateModules { basePath = ../by-name; };
in
{
  darwin =
    allModules
    ++ enumerateModules {
      prefix = "darwin-";
      basePath = ../by-name;
    };
  nixos =
    allModules
    ++ enumerateModules {
      prefix = "nixos-";
      basePath = ../by-name;
    };
  home = enumerateModules {
    prefix = "hm-";
    basePath = ../by-name;
  };
}
