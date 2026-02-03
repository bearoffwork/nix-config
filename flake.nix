{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    nix-packages.url = "github:bearoffwork/nix-packages";
    nix-packages.inputs.nixpkgs.follows = "nixpkgs-unstable";

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
      nix-packages,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      overlays = {
        mypkgs = final: _prev: {
          p = import nix-packages { inherit (final) lib system; };
        };
        unstable-pkgs = final: _prev: {
          unstable = import nixpkgs-unstable rec {
            inherit (final) lib system;
            config.allowUnfreePredicate =
              pkg:
              builtins.elem (lib.getName pkg) [
                "tart"
              ];
          };
        };
      };

      pkgsFor = forAllSystems (
        system:
        import nixpkgs-unstable {
          inherit system;
          overlays = with overlays; [
            mypkgs
            unstable-pkgs
          ];
        }
      );

      modules = import ./modules/top-level/all-modules.nix { inherit (nixpkgs) lib; };

      mkHost =
        name:
        {
          systemBuilder,
          modules ? [ ],
        }:
        systemBuilder {
          specialArgs = { inherit inputs outputs self; };
          modules = [
            {
              nixpkgs.overlays = with overlays; [
                mypkgs
                unstable-pkgs
              ];
              system.name = name;
            }
            ./hosts/${name}
          ]
          ++ modules;
        };
    in
    {
      inherit modules;

      nixosConfigurations = nixpkgs.lib.mapAttrs mkHost {
        hoard = {
          systemBuilder = nixpkgs.lib.nixosSystem;
          modules = modules.nixos;
        };
        installer = {
          systemBuilder = nixpkgs-unstable.lib.nixosSystem;
          modules = modules.nixos;
        };
        bench = {
          systemBuilder = nixpkgs-unstable.lib.nixosSystem;
          modules = modules.nixos;
        };
        rosetta = {
          systemBuilder = nixpkgs-unstable.lib.nixosSystem;
          modules = modules.nixos;
        };
        fusion = {
          systemBuilder = nixpkgs-unstable.lib.nixosSystem;
          modules = modules.nixos;
        };
      };

      darwinConfigurations = nixpkgs.lib.mapAttrs mkHost {
        grind = {
          systemBuilder = nix-darwin.lib.darwinSystem;
          modules = modules.darwin;
        };
      };

      homeConfigurations."bear@grind" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.aarch64-darwin;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./home-manager/home.nix ];
      };

      homeConfigurations."bear@hoard" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.aarch64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./home-manager/fusion.nix ];
      };

      homeConfigurations."bear@fusion" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.aarch64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./home-manager/fusion.nix ];
      };

      # packages = forAllSystems (system: {
      #   installer =
      #     (mkHost "installer" {
      #       modules = modules.nixos ++ [{nixpkgs.hostPlatform = system;}];
      #     }).config.system.build.isoImage;
      # });

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # tart
              nixos-rebuild
            ];
          };
        }
      );

      formatter = forAllSystems (system: pkgsFor.${system}.nixfmt-tree);
    };
}
