{ pkgs, ... }:
{
  imports = [
    ./docker.nix
    ./hammerspoon
  ];

  home.packages = with pkgs; [
    utm
    maccy
  ];
}
