{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.presets.zsh;
in {
  options = {
    presets.zsh = {
    };
  };

  config = mkIf (cfg.prompt == "starship") {
    programs = {
      starship = {
        enable = true;
      };

      zsh = {
        initExtra = mkIf cfg.starship.transientPrompt ''
          set-long-prompt() {
            PROMPT="$(starship prompt)"
            RPROMPT="$(starship prompt --right)"
          }
          precmd_functions+=(set-long-prompt)

          set-short-prompt() {
            if [[ $PROMPT != '%# ' ]]; then
              PROMPT="$(starship prompt --profile transient)"
              RPROMPT=""
              zle .reset-prompt 2>/dev/null # hide the errors on ctrl+c
            fi
          }

          zle-line-finish() { set-short-prompt }
          zle -N zle-line-finish

          trap 'set-short-prompt; return 130' INT
        '';
      };
    };
  };
}
