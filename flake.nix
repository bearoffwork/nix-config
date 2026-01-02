{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    # nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    # home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }@inputs:
    let
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
          overlays = [
            # outputs.overlays.additions
            # outputs.overlays.modifications
            # outputs.overlays.unstable-packages
          ];
        }
      );
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;

      nixosConfigurations = nixpkgs.lib.listToAttrs (
        map
          (sysname: {
            name = sysname;
            value = nixpkgs.lib.nixosSystem {
              specialArgs = { inherit inputs outputs sysname; };
              modules = [
                ./hosts/${sysname}
              ];
            };
          })
          [
            "bench"
            "hoard"
          ]
      );

      darwinConfigurations = {
        "grind" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs outputs self; };
          modules = [
            ./hosts/grind
          ];
        };
      };

      homeConfigurations = {
        "bear@grind" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgsFor.aarch64-darwin;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/home.nix
          ];
        };
        "bear@bench" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home-manager/bench.nix
          ];
        };
      };

      # packages = forAllSystems (system: let
      #   pkgs = nixpkgsFor.${system};
      # in {
      #   nvim-packs =
      #     pkgs.callPackage ./nvimPacks.nix {};
      # });

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          # CUDA development shell
          cuda = import ./shells/cuda.nix { inherit pkgs; };

          # llama.cpp with CUDA support
          llama = import ./shells/llama.nix { inherit pkgs; };
        }
      );
    };
}
