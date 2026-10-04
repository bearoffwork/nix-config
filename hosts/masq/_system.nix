{
  inputs,
  ...
}:
{
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    ./hardware.nix
    ./network.nix
    ./users.nix
    ./disko.nix
  ];
}
