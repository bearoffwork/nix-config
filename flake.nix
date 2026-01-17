{
  inputs = {
    # Nixpkgs branches - nixpkgs = stable, nixpkgs-unstable = bleeding edge
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    # Hardware configurations
    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";

    # System management
    nix-darwin.url = "github:nix-darwin/nix-darwin?ref=master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # Home management - separate stable and unstable versions
    home-manager.url = "github:nix-community/home-manager?ref=release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-unstable.url = "github:nix-community/home-manager?ref=master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix?ref=master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Disk management
    disko.url = "github:nix-community/disko?ref=master";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-darwin,
      home-manager,
      home-manager-unstable,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      forAllVMs =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib (
          system:
          f {
            inherit system;
            pkgs = pkgsFor system;
          }
        );

      overlays = {
        unstable-packages = final: _prev: {
          unstable = import inputs.nixpkgs-unstable {
            system = final.system;
          };
        };
      };

      modules = import ./modules/top-level/all-modules.nix { inherit (nixpkgs) lib; };

      pkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "tart"
            ];
        }
      );
    in
    {
      # Export overlays and modules for reuse
      inherit overlays modules;

      # Formatter for each system
      formatter = forAllSystems (system: pkgsFor.${system}.nixfmt);

      # Development shells for each system
      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              tart
            ];
          };
        }
      );

      # NixOS systems use stable with unstable overlay
      nixosConfigurations = nixpkgs.lib.listToAttrs (
        map
          (sysname: {
            name = sysname;
            value = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs outputs sysname; };
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
          ]
      );

      # Darwin systems use unstable
      darwinConfigurations = {
        "grind" = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs outputs self;
            sysname = "grind";
          };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
            }
            ./hosts/grind
          ]
          ++ modules.darwin;
        };
      };

      homeConfigurations = {
        "bear@grind" = home-manager-unstable.lib.homeManagerConfiguration {
          pkgs = import nixpkgs-unstable {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home.nix
          ];
        };
      };

      packages = forAllVMs (
        { system, pkgs }:
        {
          vm = nixos-generators.nixosGenerate {
            system = system;
            specialArgs = {
              pkgs = pkgs;
            };
            modules = [
              {
                # Pin nixpkgs to the flake input, so that the packages installed
                # come from the flake inputs.nixpkgs.url.
                nix.registry.nixpkgs.flake = nixpkgs;
                # set disk size to to 20G
                virtualisation.diskSize = 20 * 1024;
              }
              # Apply the rest of the config.
              ./configuration.nix
            ];
            format = "raw";
          };
        }
      );
    };
}
