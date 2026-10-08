{ lib, pkgs, ... }:
{
  # Glances REST API for homepage widget
  systemd.services.glances = {
    description = "Glances system monitor REST API";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.glances}/bin/glances --webserver --bind 127.0.0.1 --port 61208";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;

    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          disk = "/";
        };
      }
      # tank pool — size/used/free via glances fs metric
      {
        glances = {
          url = "http://127.0.0.1:61208";
          version = 4;
          metric = "fs:/tank/bear";
          diskUnits = "bytes";
          refreshInterval = 10;
        };
      }
      {
        datetime = {
          text_size = "xl";
          format = {
            timeStyle = "short";
            dateStyle = "short";
            hour12 = false;
          };
        };
      }
    ];

    settings = {
      title = "hoard";
    };
  };

  systemd.services.homepage-dashboard.environment.HOMEPAGE_ALLOWED_HOSTS =
    lib.mkForce "localhost:8082,127.0.0.1:8082,192.168.1.240:8082,192.168.254.1:8082";

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
