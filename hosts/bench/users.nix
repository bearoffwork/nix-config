{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.bear = ../../home-manager/bench.nix;

  users.defaultUserShell = pkgs.zsh;
  users.users = {
    bear = {
      extraGroups = [
        "wheel"
        # "podman"
      ];
    };
  };

  programs.zsh.enable = true;
}
