{
  pkgs,
  ...
}:

{

  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    fd
    ripgrep
    htop
    viddy
    jq
  ];

}
