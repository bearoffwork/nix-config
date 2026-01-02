{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.docker-compose
  ];
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
