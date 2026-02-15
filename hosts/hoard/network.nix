{
  networking = {
    useDHCP = false;
    useNetworkd = true;
    networkmanager.enable = false;
  };

  systemd.network = {
    enable = true;
    networks."10-sfp" = {
      matchConfig.Name = "enp4s0f0";

      address = [ "192.168.1.240/24" ];

      routes = [
        {
          Gateway = "192.168.1.254";
        }
      ];

      dns = [
        "1.1.1.1"
        "168.95.1.1"
      ];

      linkConfig.RequiredForOnline = "routable";

      networkConfig = {
        DHCP = "no";
        IPv6AcceptRA = false;
      };
    };

    # Optional: If you want the 1G NIC (enp7s0) to be a backup or
    # management port with DHCP, uncomment this:
    networks."20-rj45" = {
      matchConfig.Name = "enp7s0";
      networkConfig.DHCP = "ipv4";
      linkConfig.RequiredForOnline = "no";
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;

    allowInterfaces = [ "enp7s0" ];

    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  services.resolved = {
    enable = true;
    extraConfig = ''
      MulticastDNS=no
    '';
  };
}
