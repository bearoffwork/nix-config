{
  ...
}:
let
  wgPort = 54088;
in
{
  networking = {
    useDHCP = false;
    useNetworkd = true;
    usePredictableInterfaceNames = false;

    networkmanager.enable = false;
  };

  systemd.network.enable = true;
  systemd.network.networks."10-eth0" = {
    matchConfig.Name = "eth0";
    linkConfig.RequiredForOnline = "routable";
    networkConfig = {
      DHCP = "yes";
      IPv6PrivacyExtensions = false;
    };
  };

  # systemd.network.networks."50-wg0" = {
  #   matchConfig.Name = "wg0";
  #   address = [
  #     # /32 and /128 specifies a single address
  #     # for use on this wg peer machine
  #     "fd08:5408:3067::8/128"
  #   ];
  # };
  # systemd.network.netdevs."50-wg0" = {
  #   netdevConfig = {
  #     Kind = "wireguard";
  #     Name = "wg0";
  #   };
  #
  #   wireguardConfig = {
  #     ListenPort = wgPort;
  #     PrivateKeyFile = config.sops.secrets.wg-key.path;
  #     RouteTable = "main";
  #     FirewallMark = 42;
  #   };
  #
  #   wireguardPeers = [
  #     {
  #       # Clara
  #       PublicKey = "WAQK7Wz5uEDt2lIR3tS5WnlZ2rX85j5BD43IZekBjlg=";
  #       AllowedIPs = [
  #         "fd08:5408:3067::9/128"
  #       ];
  #     }
  #     {
  #       PublicKey = "jhdCmaSKAk+9o0QzuUJrxL+nVMXetg7/Gr9FmarN0zk=";
  #       AllowedIPs = [
  #         "fd08:5408:3067::64/128"
  #       ];
  #     }
  #   ];
  # };
}
