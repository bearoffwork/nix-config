{
  outputs,
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
    plugins = with pkgs.vimPlugins; [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (
        p: with p; [
          bash
          dockerfile
          go
          javascript
          json
          just
          lua
          markdown
          markdown-inline
          nix
          php
          python
          typescript
          xml
          yaml
          sql
          html
          css
        ]
      ))
    ];
    extraPackages = with pkgs; [
      tree-sitter
      lua-language-server
      stylua
      nixd
      nixfmt-rfc-style
      bash-language-server
      shfmt
      docker-language-server # from docker team
      docker-compose-language-service # from microsoft
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/p/nix-config/home-manager/neovim/config";
  };

  xdg.dataFile."nvim-packs" = {
    source = outputs.packages.${pkgs.system}.nvim-packs;
  };
}
