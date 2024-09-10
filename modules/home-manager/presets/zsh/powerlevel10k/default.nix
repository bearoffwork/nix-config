{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.presets.zsh;
in {
  config = mkIf (cfg.prompt == "powerlevel10k") {
    home.packages = with pkgs; [
      zsh-powerlevel10k
    ];

    programs.zsh = {
      enable = true;
      initExtra = ''
        # powerlevel10k prompt
        '.' '${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme'
        '.' '${cfg.powerlevel10k.configFile}'
      '';
    };
  };
}
