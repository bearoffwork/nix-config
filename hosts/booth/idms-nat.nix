let
  imdsIp = "192.168.5.2";
  imdsPort = "1338";
in
{

  networking.localCommands = ''
    ip route replace 169.254.169.254/32 via ${imdsIp}
  '';

  networking.nftables.tables.imds-nat = {
    family = "ip";
    content = ''
      chain output-nat {
        type nat hook output priority -100;
        ip daddr 169.254.169.254 tcp dport 80 dnat to ${imdsIp}:${imdsPort}
      }
    '';
  };
}
