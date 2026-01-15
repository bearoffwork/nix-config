{
  lib,
  pkgs,
  ...
}:
{
  config = {
    # Disable default nix-gc
    nix.gc.automatic = lib.mkDefault false;

    # Custom GC that keeps last 3 generations
    systemd.services.nix-gc-keep3 = {
      description = "Nix Garbage Collector (keep last 3)";
      startAt = "05:00";
      serviceConfig = {
        Type = "oneshot";
        CPUQuota = "30%";
        IOWeight = 100;
        Nice = 19;
      };
      script = ''
        ${pkgs.nix}/bin/nix-env -p /nix/var/nix/profiles/system --delete-generations +3
        ${pkgs.nix}/bin/nix-collect-garbage
      '';
    };
  };
}
