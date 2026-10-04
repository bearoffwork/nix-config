{
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.services.openssh;
in
{
  # options.services.openssh.hardened = mkOption {
  #   type = types.bool;
  #   default = true;
  #   description = "Whether to apply hardened security settings to OpenSSH.";
  # };
  #
  # config = mkIf cfg.hardened {
  services.openssh = {
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };
  # };
}
