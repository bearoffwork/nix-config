{ ... }:
{
  services.dnsmasq = {
    enable = true;
    bind = "127.0.0.1";
    port = 53;
    addresses = {
      "test" = "127.0.0.1";
    };
  };
  # Since the nix-darwin module doesn't handle upstream DNS servers,
  # we need to extend the launchd configuration
  # launchd.daemons.dnsmasq.serviceConfig.ProgramArguments =
  #   lib.mkAfter [
  #     "--server=1.1.1.1"
  #     "--server=168.95.1.1"
  #   ];
}
