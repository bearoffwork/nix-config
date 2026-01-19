{ inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    inputs.disko.nixosModules.disko
    ./disko.nix
    ./users.nix
    ./desktop
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
  };

  # nixpkgs.config.allowUnfreePredicate =
  #   pkg:
  #   lib.hasPrefix "cudatoolkit" (lib.getName pkg)
  #   || lib.hasPrefix "cuda-merged" (lib.getName pkg)
  #   || lib.hasPrefix "cudnn" (lib.getName pkg)
  #   || lib.hasPrefix "nvidia-x11" (lib.getName pkg)
  #   || lib.hasPrefix "nvidia" (lib.getName pkg);

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";
}
