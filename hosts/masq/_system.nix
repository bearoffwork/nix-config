{
  inputs,
  ...
}:
{
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ./hardware.nix
    ./network.nix
    ./users.nix
  ];
}
