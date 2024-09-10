{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.presets.zsh;
in {
  imports = [
    ./powerlevel10k
    ./starship
  ];

  options = {
    presets.zsh = {
      prompt = mkOption {
        type = lib.types.enum ["starship" "powerlevel10k"];
        default = "powerlevel10k";
        description = "Choose one of 'starship' 'powerlevel10k'.";
      };

      promptAtBottom = mkOption {
        default = true;
        example = true;
        description = "Whether to make prompt at bottom.";
        type = lib.types.bool;
      };

      starship.transientPrompt = mkEnableOption "starship transint prompt.";

      powerlevel10k.configFile = mkOption {
        type = types.path;
        default = "${config.xdg.configHome}/zsh/.p10k.zsh";
        description = "Where to source the powerlevel10k user config.";
      };
    };
  };

  # home.file = {
  #   "${config.xdg.configHome}/zsh/p10k.zsh".source = ./config/p10k.zsh;
  #   "${config.xdg.configHome}/starship.toml".source = ./config/starship.toml;
  # };

  config = {
    home.packages = with pkgs; [
      zsh-syntax-highlighting
      zsh-autosuggestions
      zsh-completions
      zsh-fzf-tab
      zoxide
      fzf
      eza
    ];

    programs = {
      zsh = {
        enable = true;
        defaultKeymap = "emacs";
        dotDir = ".config/zsh";

        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        historySubstringSearch.enable = true;

        history = {
          path = "${config.xdg.dataHome}/zsh/zsh_history";
        };

        plugins = [
          # use source like below to keep $PATH clean
          # {
          #   name = "fzf-tab";
          #   src = pkgs.zsh-fzf-tab;
          #   file = "share/fzf-tab/fzf-tab.plugin.zsh";
          # }
        ];

        initExtraFirst = mkIf cfg.promptAtBottom ''
          # prompt at bottom
          tput cup $(tput lines)
        '';

        initExtra = ''
          '.' '${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh'
          bindkey "^[[1;5C" forward-word
          bindkey "^[[1;5D" backward-word
        '';
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        options = ["--cmd cd"];
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      eza = {
        enable = true;
        enableZshIntegration = true;
        git = true;
        icons = true;
      };
    };
  };
}
