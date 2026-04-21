{ lib, config, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.home.srcDirectory = mkOption {
    type = types.str;
    default = "${config.home.homeDirectory}/src";
    defaultText = lib.literalExpression ''"''${config.home.homeDirectory}/src"'';
    description = ''
      Path to the source directory root. Defaults to $HOME/src.
      Override when the source tree lives outside the home directory,
      e.g. on a Lima VM where the Mac host tree is mounted at /Users/bear/src.
    '';
  };
}
