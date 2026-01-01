{ pkgs, ... }:
{
  imports = [
    ./docker.nix
    # ./skhd.nix
  ];

  home.packages = with pkgs; [
    utm
    maccy
  ];
}
