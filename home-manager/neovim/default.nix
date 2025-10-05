{
  outputs,
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
        with p; [
          go
          javascript
          xml
          yaml
          markdown
          markdown-inline
          json
          just
          lua
          nix
          php
          python
          typescript
        ]))
    ];
    extraPackages = with pkgs; [
      tree-sitter
      lua-language-server
      stylua
      nixd
      alejandra
      bash-language-server
      shfmt
    ];
  };

  xdg.configFile."nvim" = {
    source =
      config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/src/p/nix-config/home-manager/neovim/config";
  };

  xdg.dataFile."nvim-packs" = {
    source = outputs.packages.${pkgs.system}.nvim-packs;
  };
}
