{
  lib,
  pkgs,
  ...
}: let
  # see https://github.com/nvmd/nixos-raspberrypi/blob/main/overlays/linux-and-firmware.nix
  # kernelBundle = pkgs.linuxAndFirmware.latest;
  kernelBundle = pkgs.linuxAndFirmware.default;
in {
  nixpkgs.overlays = lib.mkAfter [
    (final: prev: {
      # This is used in (modulesPath + "/hardware/all-firmware.nix") when at least
      # enableRedistributableFirmware is enabled
      # I know no easier way to override this package
      inherit (kernelBundle) raspberrypiWirelessFirmware;
      # Some derivations want to use it as an input,
      # e.g. raspberrypi-dtbs, omxplayer, sd-image-* modules
      inherit (kernelBundle) raspberrypifw;
    })
  ];

  boot = {
    loader.raspberryPi.firmwarePackage = kernelBundle.raspberrypifw;
    kernelPackages = kernelBundle.linuxPackages_rpi5;
  };
}
