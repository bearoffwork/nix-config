{
  services.target = {
    enable = true;
    config = builtins.fromJSON (builtins.readFile ./target.json);
  };

  networking.firewall.allowedTCPPorts = [3260];
}
