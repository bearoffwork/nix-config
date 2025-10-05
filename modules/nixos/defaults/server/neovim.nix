{lib, ...}: {
  programs.neovim = {
    enable = lib.mkDefault true;
    viAlias = lib.mkDefault true;
    vimAlias = lib.mkDefault true;
  };
}
