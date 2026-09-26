{
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ./hardware.nix
    ./network.nix
    ./nix-settings.nix
    ./users.nix
    ./virt.nix
    ./llm
  ];

  nixpkgs = {
    config = {
      rocmSupport = true;
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "cloudflare-warp"
          "mongodb"
        ];
    };
    overlays = [
      outputs.overlays.rocm-only-gfx1151
      outputs.overlays.unstable-pkgs
    ];
  };

  environment.systemPackages = with pkgs; [
    amd-debug-tools
    amdgpu_top
    rocmPackages.rocm-smi
    rocmPackages.rocminfo
    btop-rocm
    ryzenadj
    tpm2-tss

    pciutils
    usbutils
    lm_sensors
    btop
    screen
    qrencode
    jq

    (python314.withPackages (
      p: with p; [
        numpy
        duckdb
        pandas
        huggingface-hub
      ]
    ))
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };

  programs.zsh.enable = true;

  system.stateVersion = "25.11";
}
