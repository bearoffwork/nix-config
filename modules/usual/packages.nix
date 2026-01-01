{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.usual;
in {
  options.usual.packages.enable = lib.usual.mkEnableOption "systemPackages";

  config = lib.mkIf cfg.packages.enable {
    environment.systemPackages = with pkgs; [
      fd
      htop
      jq
      just
      ripgrep
      viddy
    ];
  };
}
