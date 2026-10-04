{
  services.target = {
    enable = true;
    config = builtins.fromJSON (builtins.readFile ./target.json);
  };

  networking.firewall.interfaces."enp4s0f1".allowedTCPPorts = [3260];
}
