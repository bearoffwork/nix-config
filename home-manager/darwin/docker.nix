{ pkgs, ... }:
{
  home.packages = with pkgs; [
    colima
    unstable.lima
  ];
}
