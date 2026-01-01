{
  outputs,
  self,
  pkgs,
  ...
}:
{
  imports = [
    outputs.darwinModules.usual
    ./dnsmasq.nix
    ./nix-darwin.nix
    ./shell.nix
  ];

  nix = {
    settings = {
      trusted-users = [ "@admin" ];
      max-jobs = "auto";
      cores = 0;
      # extra-platforms = ["aarch64-linux" "x86_64-linux"];
    };
    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 8;
      config = {
        virtualisation.darwin-builder.diskSize = 30 * 1024;
        virtualisation.darwin-builder.memorySize = 16 * 1024;
        virtualisation.cores = 8;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  environment.etc = {
    "nix-darwin" = {
      source = "/Users/bear/src/p/nix-config";
    };
    "resolver/th-dev.internal" = {
      text = ''
        nameserver 172.18.0.2
      '';
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
  ];

  networking.hostName = "bear-mbw";

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
