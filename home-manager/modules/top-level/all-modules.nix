{
  lib,
  ...
}:

let
  inherit (builtins) readDir;
  inherit (lib)
    attrNames
    filterAttrs
    hasSuffix
    pathExists
    pipe
    warn
    ;

  enumerateModules =
    basePath:
    let
      isValidModule =
        name: type:
        let
          isFileModule = type == "regular" && hasSuffix ".nix" name && name != "default.nix";

          isDirModule =
            type == "directory"
            && (
              pathExists (basePath + "/${name}/default.nix")
              || warn "Skipping module ${basePath + "/${name}"}: default.nix not found" false
            );
        in
        isFileModule || isDirModule;

      renderPath = name: basePath + "/${name}";
    in
    pipe (readDir basePath) [
      (filterAttrs isValidModule)
      attrNames
      (map renderPath)
    ];
in
{
  # Pointing to the directory containing your sharded or flat modules
  imports = enumerateModules ../by-name;
}
