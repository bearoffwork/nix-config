# { lib, ... }:
# {
#   services.openssh = {
#     enable = true;
#     settings = {
#       PermitRootLogin = lib.mkForce "no";
#       PasswordAuthentication = lib.mkForce false;
#       KbdInteractiveAuthentication = lib.mkForce false;
#       X11Forwarding = false;
#     };
#   };
# }

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
  options.services.openssh.hardened = mkOption {
    type = types.bool;
    default = true;
    description = "Whether to apply hardened security settings to OpenSSH.";
  };

  config = mkIf cfg.hardened {
    services.openssh = {
      settings = {
        PermitRootLogin = mkForce "no";
        PasswordAuthentication = mkForce false;
        KbdInteractiveAuthentication = mkForce false;
        X11Forwarding = mkForce false;
      };
    };
  };
}
