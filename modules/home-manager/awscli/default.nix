{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    awscli2
  ];

  programs = {
    zsh = {
      completionInit = ''
        autoload bashcompinit && bashcompinit
        autoload -Uz compinit && compinit
      '';
      initExtra = ''
        complete -C ${pkgs.awscli2}/bin/aws_completer aws
      '';
    };
  };
}
