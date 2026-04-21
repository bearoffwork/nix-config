{
  inputs,
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./lima-guest.nix
    ./users.nix
    inputs.home-manager-unstable.nixosModules.home-manager
  ];

  nix.settings = {
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "bear@eui.money-1:4dQBVLD/RpIvnZ4CJdbDPBgWJD36Fo4j+mint4byLFg="
    ];
  };

  # image.name = "booth";
  image.modules.qemu-efi = {
    image.baseName = "booth";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  # home-manager.users.bear = ../../home-manager/booth.nix;

  system.stateVersion = "25.11";
}
