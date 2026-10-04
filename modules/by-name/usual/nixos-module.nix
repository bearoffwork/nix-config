{
  outputs,
  pkgs,
  ...
}:

{
  nixpkgs.overlays = [
    outputs.overlays.unstable-pkgs
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    use-xdg-base-directories = true;
  };

  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    curl
    wget
    fd
    ripgrep
    htop
    viddy
    jq
  ];

  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}
