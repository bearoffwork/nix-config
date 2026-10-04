{
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # fileSystems."/" = {
  #   fsType = "ext4";
  #   device = "/dev/sda";
  #   autoResize = true;
  # };

  swapDevices = lib.mkDefault [ { device = "/dev/sdb"; } ];

  boot = {
    # Add Required Kernel Modules
    # NOTE: These are not documented in the install guide
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_scsi"
      "ahci"
      "sd_mod"
    ];

    # Set Up LISH Serial Connection (Kernel level)
    kernelParams = [ "console=ttyS0,19200n8" ];
    kernelModules = [ "virtio_net" ];

    loader = {
      efi.efiSysMountPoint = "/boot/efi";

      # Increase Timeout to Allow LISH Connection
      # NOTE: The image generator tries to set a timeout of 0, so we must force
      timeout = lib.mkForce 10;

      systemd-boot = {
        enable = true;
        # systemd-boot relies on the UEFI firmware to provide serial console access
        # to the boot menu, so GRUB's manual serial config is no longer needed here.
        # The kernelParams above handle the serial connection once the kernel boots.
        consoleMode = "auto";
      };

      # systemd-boot strictly requires UEFI
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
