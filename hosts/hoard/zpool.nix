{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
  boot.zfs.package = pkgs.zfs_2_4;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs = {
    forceImportRoot = false;
    extraPools = [ "tank" ];
    devNodes = "/dev/disk/by-id";
  };

  networking.hostId = "34186bf7";

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
    trim.enable = true;
  };

  services.fstrim.enable = true;
}
