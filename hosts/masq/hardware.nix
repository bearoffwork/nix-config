{
  modulesPath,
  lib,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      "virtio_pci"
      "virtio_scsi"
      "ahci"
      "sd_mod"
    ];

    # Set Up LISH Serial Connection
    kernelParams = [ "console=ttyS0,19200n8" ];
    kernelModules = [ "virtio_net" ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };

      # Increase Timeout to Allow LISH Connection
      # NOTE: The image generator tries to set a timeout of 0, so we must force
      timeout = lib.mkForce 10;

      grub = {
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
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
