{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.defaults;
in {
  options.defaults.enableCommonPackages = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Whether to enable common packages.
    '';
  };

  #  options = {
  #    defaults.commonPackages = lib.mkOption {
  #      type = lib.types.bool;
  #      default = lib.mkDefault true;
  #      description = ''
  #        Whether to enable common system packages.
  #      '';
  #    };
  #
  #    #    defaults.utilPackages = lib.mkOption {
  #    #      type = lib.types.bool;
  #    #      default = lib.mkDefault false;
  #    #      description = "Enable common system packages (minimal set).";
  #    #    };
  #  };

  config = lib.mkIf cfg.enableCommonPackages {
    environment.systemPackages = with pkgs; [
      fd
      ripgrep
      htop
      just
      alejandra
    ];
  };
}
