{ pkgs, ... }:

let
  notifyCmd = pkgs.writeShellApplication {
    name = "nut-notify";
    runtimeInputs = with pkgs; [
      openssh
      iputils
      procps
      systemd
    ];
    text = builtins.readFile ./notify.sh;
  };
in

{
  power.ups = {
    enable = true;
    mode = "standalone";

    ups = {
      ups-nas = {
        driver = "usbhid-ups";
        port = "auto";
        description = "CyberPower PR1500LCDRT2U";
        directives = [
          "vendorid = 0764"
          "productid = 0601"
        ];
      };
    };

    users = {
      nutadmin = {
        passwordFile = "/run/secrets/nut/passwd-nutadmin";
        upsmon = "primary";
      };
    };

    upsmon = {
      monitor = {
        hoard = {
          system = "ups-nas@localhost";
          powerValue = 1;
          user = "nutadmin";
          passwordFile = "/run/secrets/nut/passwd-nutadmin";
          type = "primary";
        };
      };
    };

    # upssched = {
    #   enable = true;
    #   # low1 at 300s: warn remote, give user 5min to save work (shutdown /t 300)
    #   # low2 at 900s: by this point remote should be down (300+300+slack), poweroff hoard
    #   # LOWBATT: emergency fallback, immediate low2
    #   rules = [
    #     "AT ONBATT * START-TIMER low1 300"
    #     "AT ONBATT * START-TIMER low2 900"
    #     "AT ONLINE * CANCEL-TIMER low1"
    #     "AT ONLINE * CANCEL-TIMER low2"
    #     "AT LOWBATT * EXECUTE low2"
    #   ];
    #   commands = {
    #     low1 = "${notifyCmd}/bin/nut-notify low1";
    #     low2 = "${notifyCmd}/bin/nut-notify low2";
    #   };
    # };
  };
}
