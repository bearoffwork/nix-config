{
  outputs,
  self,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./dnsmasq.nix
    ./nix-darwin.nix
    ./shell.nix
  ];

  nix = {
    settings = {
      download-buffer-size = 524288000;
      trusted-users = [ "bear" ];
      max-jobs = "auto";
      cores = 0;
      sandbox = true;
      # extra-sandbox-paths = [
      #   "/etc/nix/netrc"
      # ];

      secret-key-files = [
        "/etc/nix/nix-store-secret.key"
      ];
    };
    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 8;
      config = {
        virtualisation = {
          darwin-builder = {
            diskSize = 120 * 1024;
            memorySize = 16 * 1024;
          };
          cores = 6;
        };
      };
    };

    extraOptions = "!include /etc/nix/access-tokens.conf";

    # extraOptions = ''
    #   netrc-file = /etc/nix/netrc
    # '';
  };

  environment.systemPackages = with pkgs; [
    neovim
    home-manager
    p.hammerspoon
  ];

  environment.etc = {
    "nix-darwin" = {
      source = "/Users/bear/src/p/nix-config";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
  ];

  system.primaryUser = "bear";
  users.users.bear = {
    name = "bear";
    home = "/Users/bear";
    isHidden = false;
    shell = pkgs.zsh;
  };

  environment.shells = [
    pkgs.zsh
  ];

  environment.profiles = lib.mkForce [
    "$HOME/.local/state/nix/profile"
    "/run/current-system/sw"
    "/nix/var/nix/profiles/default"
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
}
