{
  modulesPath,
  lib,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_scsi"
    "ahci"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot/efi";
  };

  # Increase Timeout to Allow LISH Connection
  # NOTE: The image generator tries to set a timeout of 0, so we must force
  boot.loader.timeout = lib.mkForce 10;
  boot.loader.grub = {
    enable = true;
    forceInstall = true;
    device = "/dev/sda";

    # Allow serial connection for GRUB to be able to use LISH
    extraConfig = ''
      serial --speed=19200 --unit=0 --word=8 --parity=no --stop=1;
      terminal_input serial;
      terminal_output serial
    '';
  };

  fileSystems."/" = {
    device = "/dev/sda";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/dev/sdb"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
