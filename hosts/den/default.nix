{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = let
    nixos-rpi = inputs.nixos-raspberrypi;
  in [
    nixos-rpi.lib.inject-overlays
    nixos-rpi.nixosModules.trusted-nix-caches
    nixos-rpi.nixosModules.nixpkgs-rpi

    # outputs.nixosModules.usual
    ./system
    # ./infra
  ];

  boot.tmp.useTmpfs = true;
  boot.loader.raspberryPi.bootloader = "kernel";

  # networking.hostDomain = "hope.home";

  services.udev.extraRules = ''
    # Ignore partitions with "Required Partition" GPT partition attribute
    # On our RPis this is firmware (/boot/firmware) partition
    ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
      ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
      ENV{UDISKS_IGNORE}="1"
  '';

  services.openssh = {
    enable = lib.mkDefault true;
    openFirewall = true;
    settings = {
      PermitRootLogin = lib.mkForce "no";
      PasswordAuthentication = lib.mkForce false;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    gh
  ];

  system.nixos.tags = let
    cfg = config.boot.loader.raspberryPi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];

  system.stateVersion = "25.05";
}
