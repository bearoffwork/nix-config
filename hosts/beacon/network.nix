{
  networking = {
    useDHCP = false;
    useNetworkd = true;
    networkmanager.enable = false;
  };

  systemd.network = {
    enable = true;
    networks = {

      "10-uplink" = {
        matchConfig.Name = "eth0";

        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = false;
          LinkLocalAddressing = "no";
        };

        dns = [
          "1.1.1.1"
          "168.95.1.1"
        ];
      };
    };
  };
}
