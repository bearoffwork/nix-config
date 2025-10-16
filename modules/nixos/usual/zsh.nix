{
  config,
  lib,
  fn,
  ...
}: let
  cfg = config.usual.zsh;
in {
  options.usual.zsh.enable = fn.mkUsualOption "zsh";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = lib.mkDefault true;
      autosuggestions.enable = lib.mkDefault true;
      syntaxHighlighting.enable = lib.mkDefault true;

      interactiveShellInit = fn.mkUsualBefore ''
        bindkey -e
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      '';
    };
  };
}
