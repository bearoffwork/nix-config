{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_7_2;
    # kernelParams = [
    #   "zfs.zfs_arc_max=85899345920"
    # ];
    supportedFilesystems = [ "zfs" ];
    zfs = {
      # package = pkgs.zfs_2_4;
      forceImportRoot = false;
      # extraPools = [ "tank" ];
      # devNodes = "/dev/disk/by-id";
    };
    # extraModprobeConfig = ''
    #   options zfs zfs_vdev_async_read_max_active=16 zfs_vdev_async_write_max_active=32 zfs_vdev_sync_read_max_active=32 zfs_vdev_sync_write_max_active=32 zfs_dirty_data_max=8589934592
    # '';
  };

  networking.hostId = "3f43d208";

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot.enable = true;
    trim.enable = true;
  };
}
