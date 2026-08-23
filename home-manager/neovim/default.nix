{
  config,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    sideloadInitLua = true;
    plugins = with pkgs.vimPlugins; [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (
        p: with p; [
          bash
          c
          css
          devicetree
          dockerfile
          go
          hcl
          html
          javascript
          json
          just
          kconfig
          lua
          markdown
          markdown-inline
          nix
          php
          python
          sql
          toml
          typescript
          xml
          yaml
        ]
      ))
    ];
    extraPackages = with pkgs; [
      tree-sitter
      lua-language-server
      stylua
      nixd
      nixfmt
      alejandra
      bash-language-server
      shfmt
      docker-language-server # from docker team
      docker-compose-language-service # from microsoft
      basedpyright # py lsp
      isort # py fmt
      black # py fmt
      # sqlfluff # sql fmt https://github.com/sqlfluff/sqlfluff
      # sqls # sql lsp https://github.com/sqls-server/sqls
      sql-formatter
      taplo # toml fmt
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.srcDirectory}/p/nix-config/home-manager/neovim/config";
  };
  # xdg.configFile."nvim/lsp" = {
  #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/p/nix-config/home-manager/neovim/config/lsp";
  # };
  # xdg.configFile."nvim/lua" = {
  #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/p/nix-config/home-manager/neovim/config/lua";
  # };

  xdg.dataFile."nvim-packs" = {
    source = pkgs.callPackage ./nvim-packs.nix { };
  };
}
