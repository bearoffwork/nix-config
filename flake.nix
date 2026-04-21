{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    nix-packages.url = "github:bearoffwork/nix-packages";
    nix-packages.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";

    nix-darwin.url = "github:nix-darwin/nix-darwin?ref=master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-lima.url = "github:nixos-lima/nixos-lima/master";
    nixos-lima.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL?ref=main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager?ref=release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-unstable.url = "github:nix-community/home-manager?ref=master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    sops-nix.url = "github:Mic92/sops-nix?ref=master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko?ref=master";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      ...
    }:

    let
      inherit (self) outputs inputs;
      inherit (inputs.nixpkgs-unstable) lib;

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;

      pkgs-overlays = [
        # release
        (final: prev: {
          stable = import inputs.nixpkgs { inherit (final.stdenv.hostPlatform) system; };
        })
        # latest
        (final: prev: {
          unstable = import inputs.nixpkgs-unstable { inherit (final.stdenv.hostPlatform) system; };
        })
        # mypkgs
        (final: _prev: {
          p = inputs.nix-packages.packages.${final.stdenv.hostPlatform.system};
        })
      ];

      pkgsFor = forAllSystems (
        system:
        import inputs.nixpkgs-unstable {
          inherit system;
          overlays = pkgs-overlays;
        }
      );

      modules = lib.mapAttrs (name: m: m ++ [ { nixpkgs.overlays = pkgs-overlays; } ]) (
        import ./modules/top-level/all-modules.nix { inherit lib; }
      );

      mkHost =
        systemModules: name:
        {
          systemBuilder ? inputs.nixpkgs-unstable.lib.nixosSystem,
          modules ? [ ],
        }:
        systemBuilder {
          specialArgs = { inherit inputs outputs self; };
          modules = [
            { system.name = name; }
            ./hosts/${name}
          ]
          ++ systemModules
          ++ modules;
        };
    in
    {
      inherit modules inputs;

      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
        in
        {
          booth-image = self.nixosConfigurations.booth.config.system.build.images.qemu-efi;
        }
      );

      nixosConfigurations = lib.mapAttrs (mkHost modules.nixos) {
        hoard = {
          systemBuilder = inputs.nixpkgs.lib.nixosSystem;
        };
        installer = { };
        bench = { };
        rosetta = { };
        fusion = { };
        booth = { };
        hydrus = {
          systemBuilder = inputs.nixpkgs.lib.nixosSystem;
        };
      };

      darwinConfigurations = lib.mapAttrs (mkHost modules.darwin) {
        grind = {
          systemBuilder = inputs.nix-darwin.lib.darwinSystem;
        };
      };

      homeConfigurations =
        let
          hmConfig = inputs.home-manager-unstable.lib.homeManagerConfiguration;

          mkHome =
            system: modules:
            let
              pkgs = pkgsFor.${system};
            in
            hmConfig {
              inherit pkgs modules;
              extraSpecialArgs = { inherit inputs outputs; };
            };
        in
        {
          "bear@grind" = mkHome "aarch64-darwin" [
            ./home-manager/home.nix
          ];

          "bear@rosetta" = mkHome "x86_64-linux" [
            ./home-manager/fusion.nix
          ];

          "bear@booth" = mkHome "aarch64-linux" [
            ./home-manager/booth.nix
          ];

          "bear@fusion" = mkHome "aarch64-linux" [
            ./home-manager/fusion.nix
          ];
        };

      formatter = forAllSystems (system: pkgsFor.${system}.nixfmt-tree);
    };
}
