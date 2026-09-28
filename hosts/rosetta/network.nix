{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  wgPort = 54088;
in
{
  sops.secrets.wg-key = {
    sopsFile = "${inputs.self.outPath}/secrets/wg.json";
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking = {
    useDHCP = false;
    useNetworkd = true;
    networkmanager.enable = false;
    firewall = {
      allowedTCPPorts = [
        8080
        5000
      ];
      allowedUDPPorts = [
        wgPort
      ];
    };
  };

  systemd.network = {
    enable = true;
    networks = {

      "10-uplink" = {
        matchConfig.Name = "enp191s0";

        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          DHCP = "yes";
          IPv6AcceptRA = false;
          LinkLocalAddressing = "no";
        };

        dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        linkConfig.MTUBytes = 9000;
      };

      "50-wg0" = {
        matchConfig.Name = "wg0";

        address = [
          # /32 and /128 specifies a single address
          # for use on this wg peer machine
          "fd08:5408:3067::8/128"
        ];
      };

    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = wgPort;
        PrivateKeyFile = config.sops.secrets.wg-key.path;
        RouteTable = "main";
        FirewallMark = 42;
      };

      wireguardPeers = [
        {
          # Clara
          PublicKey = "WAQK7Wz5uEDt2lIR3tS5WnlZ2rX85j5BD43IZekBjlg=";
          AllowedIPs = [
            "fd08:5408:3067::9/128"
          ];
        }
        {
          PublicKey = "jhdCmaSKAk+9o0QzuUJrxL+nVMXetg7/Gr9FmarN0zk=";
          AllowedIPs = [
            "fd08:5408:3067::64/128"
          ];
        }
      ];
    };

  };

  environment.systemPackages = [
    pkgs.cloudflare-warp
  ];

  services.cloudflare-warp.enable = true;

  # services.sing-box = {
  #   enable = true;
  #   settings = {
  #     inbounds = [
  #       {
  #         type = "tun";
  #         tag = "tun-in";
  #         address = [ "172.19.0.1/30" ];
  #         auto_route = true;
  #         strict_route = false; # Critical: Keeps your local 10GbE network and SSH accessible
  #       }
  #     ];
  #
  #     outbounds = [
  #       {
  #         type = "direct";
  #         tag = "direct";
  #       }
  #       {
  #         type = "socks";
  #         tag = "warp-socks";
  #         server = "127.0.0.1";
  #         server_port = 40000;
  #       }
  #     ];
  #
  #     route = {
  #       auto_detect_interface = true;
  #       rules = [
  #         {
  #           inbound = "tun-in";
  #           action = "sniff"; # <-- ADDED: Extracts domain from TLS before routing
  #         }
  #         {
  #           port = 53;
  #           outbound = "direct"; # Let normal system DNS queries pass directly
  #         }
  #         {
  #           domain_suffix = [
  #             "github.com"
  #             "githubusercontent.com"
  #             "ghcr.io"
  #             "nixos.org"
  #           ];
  #           outbound = "warp-socks"; # Route these domains to Cloudflare WARP
  #         }
  #       ];
  #       final = "direct"; # Everything else bypasses the proxy
  #     };
  #   };
  # };

}
