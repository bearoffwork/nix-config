{
  config,
  lib,
  ...
}: let
  cfg = config.defaults.server;
in {
  options.defaults.server = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to enable server-specific defaults.
        Including:
        - ssh server
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    imports = [
      ./neovim.nix
    ];

    services.openssh = {
      enable = lib.mkDefault true;
      openFirewall = lib.mkDefault true;
      settings = {
        PasswordAuthentication = lib.mkDefault false;
        PermitRootLogin = lib.mkDefault "no";
      };
    };
  };
}
