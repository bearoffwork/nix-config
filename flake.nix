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
          overlays = [ overlays.unstable-pkgs ];
        }
      );

      modules = import ./modules/top-level/all-modules.nix { inherit (nixpkgs) lib; };

      mkHost =
        {
          name,
          systemBuilder ? nixpkgs-unstable.lib.nixosSystem,
          modules ? [ ],
        }:
        let
          # platformModules =
          #   if platform == "darwin"
          #   then modules.darwin
          #   else modules.nixos;
        in
        {
          inherit name;
          value = systemBuilder {
            specialArgs = { inherit inputs outputs self; };
            modules = [
              {
                nixpkgs.overlays = [ overlays.unstable-pkgs ];
                system.name = name;
              }
              ./hosts/${name}
            ]
            ++ modules;
          };
        };

      mkHosts = configs: nixpkgs.lib.listToAttrs (map mkHost configs);
    in
    {
      inherit modules;

      nixosConfigurations = mkHosts [
        {
          name = "hoard";
          systemBuilder = nixpkgs.lib.nixosSystem;
          modules = modules.nixos;
        }
        {
          name = "installer";
          modules = modules.nixos;
        }
        {
          name = "bench";
          modules = modules.nixos;
        }
        {
          name = "rosetta";
          modules = modules.nixos;
        }
      ];

      darwinConfigurations = mkHosts [
        {
          name = "grind";
          systemBuilder = nix-darwin.lib.darwinSystem;
          modules = modules.darwin;
        }
      ];

      homeConfigurations."bear@grind" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.aarch64-darwin;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./home-manager/home.nix ];
      };

      homeConfigurations."bear@rosetta" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [ ./home-manager/rosetta.nix ];
      };

      packages = forAllSystems (system: {
        installer =
          (mkHost {
            name = "installer";
            modules = modules.nixos ++ [ { nixpkgs.hostPlatform = system; } ];
          }).value.config.system.build.isoImage;
      });

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
