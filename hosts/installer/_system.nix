{
  modules = [
    (
      {
        inputs,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];

        # Disable compression for faster builds
        # isoImage.squashfsCompression = "gzip -Xcompression-level 1";
        isoImage.compressImage = false;

        users.users.nixos = {
          extraGroups = [ "wheel" ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcb/6hU5JzxclQYwUwARgj7mnE389S6/R6QjpII30Sv"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPqnVSfFBTMqSOmgrTCl8rPUDxakVeNTyBTMVuTgqDC bear@bench.bearoff.work"
            "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIBa2WGEtVhHDLyyTXO2pbth+d4MNMVhaiO2ltYuBtkjUAAAABHNzaDo= code@bearoff.work"
          ];
        };

        boot = {
          kernelPackages = pkgs.linuxKernel.packages.linux_7_2;
          # kernelParams = [
          #   "zfs.zfs_arc_max=85899345920"
          # ];
          initrd.supportedFilesystems = [ "zfs" ];
          zfs = {
            package = pkgs.zfs_2_4;
            forceImportRoot = false;
            devNodes = "/dev/disk/by-uuid";
          };
          # extraModprobeConfig = ''
          #   options zfs zfs_vdev_async_read_max_active=16 zfs_vdev_async_write_max_active=32 zfs_vdev_sync_read_max_active=32 zfs_vdev_sync_write_max_active=32 zfs_dirty_data_max=8589934592
          # '';
        };

        networking.hostId = "ff0000be";

        services.getty.autologinUser = "nixos";

        security.sudo.wheelNeedsPassword = false;

        # Don't hardcode - allow override via --system
        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        system.stateVersion = "25.11";
      }
    )
  ];
}
