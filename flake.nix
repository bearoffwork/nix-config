{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";

    nix-darwin.url = "github:nix-darwin/nix-darwin?ref=master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL?ref=main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager?ref=master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    sops-nix.url = "github:Mic92/sops-nix?ref=master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko?ref=master";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      overlays = {
        unstable-packages = final: _prev: {
          unstable = import nixpkgs-unstable {
            inherit (final) system;
            config.allowUnfree = true;
          };
        };
      };

      modules = import ./modules/top-level/all-modules.nix { inherit (nixpkgs) lib; };

      pkgsFor =
        nixpkgs: system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
    in
    {
      inherit overlays modules;

      devShells = forAllSystems (system: {
        default = (pkgsFor nixpkgs-unstable system).mkShell {
          packages = [ (pkgsFor nixpkgs-unstable system).tart ];
        };
      });

      nixosConfigurations = nixpkgs.lib.listToAttrs (
        map
          (sysname: {
            name = sysname;
            value = nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs outputs sysname;
              };
              modules = [
                {
                  nixpkgs.overlays = [ overlays.unstable-packages ];
                  nixpkgs.config.allowUnfree = true;
                }
                ./hosts/${sysname}
              ]
              ++ modules.nixos;
            };
          })
          [
            "hoard"
            "bench"
            "rosetta"
            "installer"
          ]
      );

      darwinConfigurations.grind = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs outputs self;
          sysname = "grind";
        };
        modules = [
          { nixpkgs.config.allowUnfree = true; }
          ./hosts/grind
        ]
        ++ modules.darwin;
      };

      homeConfigurations."bear@grind" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor nixpkgs-unstable "aarch64-darwin";
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./home-manager/home.nix ];
      };

      packages = forAllSystems (system: {
        installer = self.nixosConfigurations.installer.config.system.build.isoImage;
      });

      formatter = forAllSystems (system: (pkgsFor nixpkgs-unstable system).nixfmt);
    };
}
