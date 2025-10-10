{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    nixpkgsFor = forAllSystems (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            # outputs.overlays.additions
            # outputs.overlays.modifications
            # outputs.overlays.unstable-packages
          ];
        }
    );
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    nixosModules = import ./modules/nixos;

    nixosConfigurations = nixpkgs.lib.listToAttrs (map (hostname: {
        name = hostname;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs hostname;};
          modules = [
            {defaults.trustedUsers = ["bear"];}
            ./hosts/${hostname}
          ];
        };
      }) [
        "wtwsl"
        "nas"
      ]);

    darwinConfigurations = {
      bear-mbw = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs self;};
        modules = [
          ./hosts/bear-mbw
        ];
      };
    };

    homeConfigurations = {
      "bear@bear-mbw" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgsFor.aarch64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
        ];
      };
    };

    # packages = forAllSystems (system: let
    #   pkgs = nixpkgsFor.${system};
    # in {
    #   nvim-packs =
    #     pkgs.callPackage ./nvimPacks.nix {};
    # });
  };
}
