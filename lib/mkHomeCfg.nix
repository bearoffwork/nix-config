{
  inputs,
  outputs,
}: username: system:
with inputs;
  home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.${system};
    extraSpecialArgs = {inherit inputs outputs username;};
    modules = [
      ../users/${username}
      ({
        lib,
        pkgs,
        ...
      }:
        with lib; {
          xdg.enable = mkDefault true;
          home.username = mkDefault username;
          home.homeDirectory = mkDefault (
            if pkgs.stdenv.isDarwin
            then "/Users/${username}"
            else "/home/${username}"
          );
        })
    ];
  }
