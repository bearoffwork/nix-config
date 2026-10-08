{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware?ref=master";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

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
    { ... }@inputs:
    let
      inherit (inputs.self) outputs;
      inherit (inputs.nixpkgs-unstable) lib;

      modules = import ./modules/top-level/all-modules.nix { inherit lib; };
      overlays = import ./overlays { inherit inputs outputs; };

      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
      pkgsFor = forAllSystems (
        system:
        import inputs.nixpkgs-unstable {
          inherit system;
          overlays = [ overlays.unstable-pkgs ];
        }
      );

    in
    {
      inherit inputs modules overlays;

      # modules = lib.mapAttrs (name: m: m ++ [ { nixpkgs.overlays = pkgs-overlays; } ]) (
      #   import ./modules/top-level/all-modules.nix { inherit lib; }
      # );

      nixosConfigurations = import ./hosts {
        inherit inputs outputs;
        extraModules = modules.nixos;
      };

      formatter = forAllSystems (system: pkgsFor.${system}.unstable.nixfmt-tree);
    };
}
