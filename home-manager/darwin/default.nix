{ pkgs, ... }:
{
  imports = [
    ./docker.nix
  ];

  home.packages = with pkgs; [
    utm
    maccy
  ];
}
