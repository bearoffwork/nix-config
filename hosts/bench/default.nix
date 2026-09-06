{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./docker.nix
    ./users.nix
    # ./nvidia.nix
  ];

  networking.hostName = "bench";
  networking.domain = "hope.home";
  networking.firewall.allowedTCPPorts = [
    5173
  ];

  environment.systemPackages = with pkgs; [
    kmod
    usbutils
    stlink
    opencode
  ];

  services.udev.extraRules = ''
    # Force rw permissions for ST-Link (0483:3748)
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666"
  '';

  wsl = {
    enable = true;
    defaultUser = "bear";
    useWindowsDriver = true;
    # wslConf = {
    #   network = {
    #     networkingMode = "mirrored";
    #     dnsTunneling = true;
    #   };
    # };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
