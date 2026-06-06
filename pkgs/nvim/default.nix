{
  lib,
  pkgs,
  ...
}:
let
  fetchPlugins =
    args:
    builtins.mapAttrs (
      name: spec:
      let
        plugin = (spec { inherit pkgs; }).outPath;
      in
      if plugin ? overrideAttrs then
        plugin.overrideAttrs { name = lib.strings.sanitizeDerivationName name; }
      else
        # `startAttrs` expects store paths
        "${plugin}"
    ) (import ./npins args);
in
{
  appName = "nvim";

  extraBinPath = with pkgs; [
    emmylua-ls
    tinymist
    nixd

    stylua
    nixfmt

    websocat
  ];

  initLua = /* lua */ ''
    vim.loader.enable() -- enable this asap

    vim.o.exrc = true -- has to be set early
    vim.g.loaded_netrw = true
    vim.g.loaded_nvim_treesitter = true
  '';

  plugins = {
    dev."+config" = {
      pure = lib.fileset.toSource {
        root = ./.;
        fileset = lib.fileset.unions [
          ./lua
          ./plugin
          ./queries
          ./ftplugin
        ];
      };
      impure = toString ./.;
    };

    start = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];

    startAttrs = fetchPlugins {
      input = ./npins/plugins.json;
    };
  };
}
