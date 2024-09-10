{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # Also see the 'stable-packages' overlay at 'overlays/default.nix'.

    # nix-darwin
    # https://github.com/LnL7/nix-darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home manager
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixvim
    # https://github.com/nix-community/nixvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
    mkHomeCfg = import ./lib/mkHomeCfg.nix {inherit inputs outputs;};
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    commonModules = import ./modules/common;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    # nixosConfigurations = {
    #   # FIXME replace with your hostname
    #   your-hostname = nixpkgs.lib.nixosSystem {
    #     specialArgs = {inherit inputs outputs;};
    #     modules = [
    #       ./hosts/nixos-example
    #     ];
    #   };
    # };
    darwinConfigurations = {
      "bear-mbw" = darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs self;};
        modules = [
          ./hosts/bear-mbw
        ];
        system = "aarch64-darwin";
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "bear@bear-mbw" = mkHomeCfg "bear" "aarch64-darwin";
      "scl@SCLs-M3-Pro" = mkHomeCfg "scl" "aarch64-darwin";
    };
  };
}
