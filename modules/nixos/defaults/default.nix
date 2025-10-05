{
  lib,
  hostname,
  ...
}: {
  imports = [
    ./common
  ];
  options.defaults = {
    trustedUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = lib.mkDefault [];
      description = ''
        List of trusted users for sudo and other privileged operations.
      '';
    };
  };

  config = {
    networking.hostName = lib.mkDefault hostname;
  };
}
