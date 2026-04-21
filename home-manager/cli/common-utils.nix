{
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    pwgen
  ];

  # TODO
  # home.shellAlias = {
  #   "pwgen" = ''
  #     ${lib.getExe pkgs.pwgen} -cnysvBr"\"\'\`\$\\#%&:;|<>()[]{}/" \${1 - 8}
  #   '';
  # };
}
