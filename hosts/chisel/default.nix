{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    inputs.disko.nixosModules.disko
    ./disko.nix
    ./hardware-configuration.nix
    ./users.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager = {
    enable = true;
    dns = "none";
    insertNameservers = [
      "1.1.1.1"
      "168.95.1.1"
    ];
  };
  networking.nameservers = [
    "1.1.1.1"
    "168.95.1.1"
  ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
    mesa-demos
    adwaita-icon-theme
    flat-remix-icon-theme
    pciutils
  ];

  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
  };

  programs.hyprland.enable = true;
  programs.niri.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Flat-Remix-Red-Dark";
        font-name = "Noto Sans Medium 11";
        document-font-name = "Noto Sans Medium 11";
        monospace-font-name = "Noto Sans Mono Medium 11";
      };
    }
  ];

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland"; # Path to Hyprland binary
      };
    };
  };

  users.defaultUserShell = pkgs.zsh;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";
}
