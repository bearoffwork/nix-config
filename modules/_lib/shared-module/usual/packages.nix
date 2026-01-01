{
  config,
  lib,
  pkgs,
  fn,
  ...
}:
let
  cfg = config.usual;
in
{
  options.usual.packages.enable = fn.mkUsualOption "systemPackages";

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
