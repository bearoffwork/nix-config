{
  networking = {
    useDHCP = false;
    useNetworkd = true;
    networkmanager.enable = false;

    firewall.interfaces."enp4s0f1" = {
      allowedTCPPorts = [
        445 # SMB/CIFS
        139 # SMB/CIFS
        3260 # iSCSI Target
      ];

      allowedUDPPorts = [
        67 # DHCP
        137 # NetBIOS
        138 # NetBIOS
      ];
    };
  };

  systemd.network = {
    enable = true;
    networks = {

      "10-uplink" = {
        matchConfig.Name = "enp4s0f0";

        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          DHCP = "no";
          IPv6AcceptRA = false;
          LinkLocalAddressing = "no";
        };

        address = [ "192.168.1.240/24" ];
        routes = [ { Gateway = "192.168.1.254"; } ]; # Gateway goes ONLY here
        dns = [
          "1.1.1.1"
          "168.95.1.1"
        ]; # DNS goes ONLY here
        linkConfig.MTUBytes = 9000;
      };

      "11-storage" = {
        matchConfig.Name = "enp4s0f1";
        address = [ "192.168.254.1/24" ];

        linkConfig = {
          RequiredForOnline = "routable";
          MTUBytes = 9000;
          Multicast = true;
        };

        networkConfig = {
          DHCP = "no"; # This means "do not act as a DHCP client"
          IPv6AcceptRA = false;
          LinkLocalAddressing = "no";

          # Enable the DHCP server on this port
          DHCPServer = "yes";
          MulticastDNS = "yes";
        };

        dhcpServerConfig = {
          # CRITICAL: Prevent Windows from trying to use this as an internet gateway
          EmitRouter = false;
          # CRITICAL: Prevent Windows from trying to use this for DNS
          EmitDNS = false;
          # Hand out IPs starting at 10.254.0.10
          PoolOffset = 10;
        };
      };

    };
  };

  services.resolved = {
    enable = true;
    extraConfig = ''
      MulticastDNS=true
    '';
  };
}
