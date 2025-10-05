{pkgs, ...}: {
  environment.variables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    LANG = "en_US.UTF-8";
  };

  programs.zsh = {
    enable = true;
    enableBashCompletion = true;
    #    enableFzfCompletion = true;
    #    enableFzfGit = true;
    #    enableFzfHistory = true;
    #    variables.cfg = "/etc/nix-darwin/configuration.nix";
    #    variables.darwin = "$HOME/.nix-defexpr/darwin";
    #    variables.nixpkgs = "$HOME/.nix-defexpr/nixpkgs";
  };
}
