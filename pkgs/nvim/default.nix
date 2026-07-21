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
    nixd

    stylua
    nixfmt
  ];

  initLua = /* lua */ ''
    vim.loader.enable() -- enable this asap

    vim.o.exrc = true -- has to be set early
    vim.g.loaded_netrw = true
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

    start = builtins.concatMap (
      grammar: [ grammar ] ++ lib.optional (grammar ? associatedQuery) grammar.associatedQuery
    ) (builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins);

    startAttrs = fetchPlugins {
      input = ./npins/plugins.json;
    };
  };
}
