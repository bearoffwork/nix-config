{
  inputs,
  ...
}:
{
  modules = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ./default.nix
    ./network.nix
    ./zpool.nix
    # ./iscsi
    # ./homepage.nix
    ./smb.nix
    ./users.nix
    ./ups
  ];
}
