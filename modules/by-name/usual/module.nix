{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    neovim
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
