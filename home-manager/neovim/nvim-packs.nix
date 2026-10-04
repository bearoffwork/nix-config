{
  lib,
  pkgs,
  stdenv,
}:
let
  startPlugins = with pkgs.vimPlugins; [
    lz-n
    plenary-nvim
  ];

  optPlugins = with pkgs.vimPlugins; [
    blink-cmp
    catppuccin-nvim
    conform-nvim
    diffview-nvim
    lazydev-nvim
    mini-nvim
    neotest
    nvim-lspconfig
    oil-nvim
    render-markdown-nvim
    telescope-nvim
    todo-comments-nvim
    toggleterm-nvim
    # vim-dadbod
    # vim-dadbod-completion
  ];
  # Define plugins here first
  mkPluginMap =
    plugins:
    builtins.listToAttrs (
      map (plugin: {
        name = plugin.pname or (builtins.baseNameOf plugin);
        value = plugin;
      }) plugins
    );

  startPluginMap = mkPluginMap startPlugins;
  optPluginMap = mkPluginMap optPlugins;

  mkLink =
    plugins: toPath:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: pluginPath:
        let
          dirPath = if builtins.match ".*/.*" name != null then builtins.dirOf name else "";
        in
        if dirPath != "" then
          ''
            mkdir -p "${toPath}/${dirPath}"
            ln -sf "${pluginPath}" "${toPath}/${name}"
          ''
        else
          ''
            ln -sf "${pluginPath}" "${toPath}/${name}"
          ''
      ) plugins
    );
in
stdenv.mkDerivation {
  pname = "nvim-pack";
  version = "0.1.0";
  src = null;

  buildInputs = startPlugins ++ optPlugins;

  installPhase = ''
    mkdir -p $out/pack/plugins/start
    mkdir -p $out/pack/plugins/opt
    # Link start plugins (auto-loaded)
    ${mkLink startPluginMap "$out/pack/plugins/start"}

    # Link opt plugins (manually loaded)
    ${mkLink optPluginMap "$out/pack/plugins/opt"}
  '';

  dontUnpack = true;
  dontBuild = true;
}
