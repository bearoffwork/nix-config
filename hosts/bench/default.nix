{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    # ./docker.nix
    ./users.nix
    # ./nvidia.nix
  ];

  networking.hostName = "bench";
  networking.domain = "hope.home";

  wsl = {
    enable = true;
    defaultUser = "bear";
    useWindowsDriver = true;
    wslConf = {
      network = {
        networkingMode = "mirrored";
        dnsTunneling = true;
      };
    };
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "25.05";
}
