# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    outputs.nixosModules.defaults
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    #    inputs.home-manager.nixosModules.home-manager
    ./zpool.nix
    ./users.nix
  ];

  defaults.server.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelModules = [
    "nct6775" # asrock b550m pg riptide sensors
  ];

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Taipei";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "lsiutil"
      "storcli"
    ];

  environment.systemPackages = with pkgs; [
    curl
    wget

    alejandra

    pciutils # provides lspci
    usbutils # provides lsusb
    smartmontools # for drive testing
    sg3_utils # SAS utilities
    lshw # hardware detection
    hdparm # drive testing
    lsiutil
    storcli
    lm_sensors
    powertop
    htop
    bottom
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [22 80 443];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "25.05";
}
