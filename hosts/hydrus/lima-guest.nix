{
  inputs,
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.nixos-lima.nixosModules.lima
    (inputs.nixos-lima + "/lima-init.nix")
  ];

  services.lima.enable = true;
  services.openssh = {
    enable = true;
    hardened = false;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = true;
    };
  };

  boot = {
    loader.grub = {
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  fileSystems."/boot" = {
    # device = lib.mkForce "/dev/vda1";
    device = lib.mkForce "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
    options = [
      "noatime"
      "nodiratime"
      "discard"
    ];
  };

  nixpkgs.hostPlatform = "aarch64-linux";
}
