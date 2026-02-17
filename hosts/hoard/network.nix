{
  networking = {
    useDHCP = false;
    useNetworkd = true;
    networkmanager.enable = false;
  };

  systemd.network = {
    enable = true;
    networks =
      let
        netConf = {
          matchConfig.Name = "enp4s0f0";
          address = [ "192.168.1.240/24" ];
          routes = [
            { Gateway = "192.168.1.254"; }
          ];

          dns = [
            "1.1.1.1"
            "168.95.1.1"
          ];

          linkConfig.RequiredForOnline = "routable";

          networkConfig = {
            DHCP = "no";
            IPv6AcceptRA = false;
            LinkLocalAddressing = "no";
          };
        };
      in
      {
        "10-sfp" = netConf // {
          matchConfig.Name = "enp4s0f0";
          address = [ "192.168.1.240/24" ];
        };

        "20-rj45" = netConf // {
          matchConfig.Name = "enp7s0";
          address = [ "192.168.1.239/24" ];
        };
      };
  };
}
