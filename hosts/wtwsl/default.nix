{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    outputs.nixosModules.defaults
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  wsl.enable = true;
  wsl.defaultUser = "bear";

  environment.systemPackages = with pkgs; [
    ripgrep
    fd
    viddy # watch
    alejandra
    just
  ];

  system.stateVersion = "25.05";
}
