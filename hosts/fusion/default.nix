{
  inputs,
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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.firewall.enable = false;
  networking.networkmanager = {
    enable = true;
    dns = "none";
    insertNameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  environment.systemPackages = with pkgs; [
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

  services.xserver.enable = true;
  programs.hyprland = {
    enable = true;
  };

  programs.zsh.enable = true;

  virtualisation.vmware.guest.enable = true;

  users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "25.11";
}
