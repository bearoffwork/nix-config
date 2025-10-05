{
  lib,
  pkgs,
  ...
}: {
  config.programs.zsh =
    {
      enable = lib.mkDefault true;

      interactiveShellInit = lib.mkDefault ''
        bindkey -e
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      '';
    }
    // lib.mkIf pkgs.stdenv.isLinux {
      enableCompletion = lib.mkDefault true;
      autosuggestions.enable = lib.mkDefault true;
      syntaxHighlighting.enable = lib.mkDefault true;
    }
    // lib.mkIf pkgs.stdenv.isDarwin {
      enableCompletion = lib.mkDefault true;
      enableBashCompletion = lib.mkDefault true;
      enableAutosuggestions = lib.mkDefault true;
      enableFastSyntaxHighlighting = lib.mkDefault true;
      enableFzfCompletion = lib.mkDefault true;
      # enableFzfGit = lib.mkDefault true;
      enableFzfHistory = lib.mkDefault true;
      interactiveShellInit = lib.mkDefault ''
        bindkey -e
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      '';
    };
}
