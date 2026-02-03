{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
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
    xrandr
    wl-clipboard
    mesa-demos
    adwaita-icon-theme
    flat-remix-icon-theme
    spice-vdagent # utm clipboard
    pciutils

    # Copied from https://github.com/mitchellh/nixos-config/blob/main/machines/vm-shared.nix
    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
  };

  console.font = "ter-u32n";

  # virtualisation.vmware.guest.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = false; # Not supported on aarch64
    extraPackages = with pkgs; [
      mesa.drivers
    ];
  };

  # Ensure virtio-gpu module is loaded with proper options
  boot.kernelModules = [ "virtio_gpu" ];
  boot.extraModprobeConfig = ''
    options virtio_gpu modeset=1
  '';

  services.qemuGuest.enable = true;

  programs.zsh.enable = true;

  programs.hyprland.enable = true;
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

  system.stateVersion = "25.11";
}
