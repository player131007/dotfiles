{
  lib,
  pkgs,
  ...
}:
let
  fetchPlugins =
    let
      fetch = _: spec: spec { inherit pkgs; };
      addInfo =
        name: spec:
        if lib.isDerivation spec.outPath then
          spec.outPath.overrideAttrs { name = lib.strings.sanitizeDerivationName name; }
        else
          # `startAttrs` expects store paths
          "${spec.outPath}";
    in
    args:
    lib.pipe (import ./npins args) [
      (lib.mapAttrs fetch)
      (lib.mapAttrs addInfo)
    ];
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
