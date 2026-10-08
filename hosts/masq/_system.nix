{
  inputs,
  ...
}:
{
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    ./disko.nix
    ./hardware.nix
    ./network.nix
    ./users.nix
  ];
}
