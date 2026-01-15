{
  inputs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    inputs.disko.nixosModules.disko
    ./disko.nix
    ./users.nix
  ];

  # nixpkgs.config.allowUnfreePredicate =
  #   pkg:
  #   lib.hasPrefix "cudatoolkit" (lib.getName pkg)
  #   || lib.hasPrefix "cuda-merged" (lib.getName pkg)
  #   || lib.hasPrefix "cudnn" (lib.getName pkg)
  #   || lib.hasPrefix "nvidia-x11" (lib.getName pkg)
  #   || lib.hasPrefix "nvidia" (lib.getName pkg);

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.11";
}
