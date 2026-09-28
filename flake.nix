{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";

    nixos-images.url = "github:nix-community/nixos-images";
    nixos-images.inputs.nixos-unstable.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # llama-fork.url = "github:pwilkin/llama.cpp?ref=strix-halo";
    llama-fork.url = "github:halo-box/strix-llama.cpp";
    llama-fork.flake = false;
  };

  outputs =
    inputs@{ ... }:
    let
      inherit (inputs.self) outputs;
      inherit (inputs.nixpkgs-unstable) lib;

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;

      pkgs-overlays = [
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
    in
    {
      inherit inputs;
      overlays = import ./overlays { inherit inputs outputs; };

      nixosConfigurations = import ./hosts { inherit inputs outputs; };

      formatter = forAllSystems (system: pkgsFor.${system}.nixfmt-tree);
    };
}
