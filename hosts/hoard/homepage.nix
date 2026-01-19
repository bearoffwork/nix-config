{ ... }:
{
  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
  };

  users.users.homepage = {
    isSystemUser = true;
    extraGroups = [ "sensors" ];
  };

  security.sudo.extraRules = [
    {
      groups = [ "sensors" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/storcli64 /c0 show temperature J";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/storcli64 /c0 show all J";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
