{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./lima-guest.nix
    ./users.nix
    ./idms-nat.nix
    inputs.home-manager-unstable.nixosModules.home-manager
  ];

  networking.nftables.enable = true;

  environment.systemPackages = with pkgs; [
    nh
  ];

  nix.settings = {
    trusted-users = [ "bear" ];
    substituters = [
      "s3://nix-cache-268054298234-ap-east-2-an?region=ap-east-2"
    ];
    trusted-public-keys = [
      "hydrus@eui.money-1:SnDYeQLMwu1k5DPR2L//f+TN+OnF/U9w3v6Mdm2PG1c="
    ];
  };
  nix.extraOptions = "!include /etc/nix/access-tokens.conf";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.bear = ../../home-manager/booth.nix;

  system.stateVersion = "25.11";
}
