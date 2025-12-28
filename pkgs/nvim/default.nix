{
  lib,
  pkgs,
  ...
}:
let
  sources = lib.pipe ./npins [
    import
    (builtins.mapAttrs (_: source: source { inherit pkgs; }))
    (builtins.mapAttrs (
      name: spec:
      spec
      // lib.optionalAttrs (lib.isDerivation spec.outPath) {
        outPath = spec.outPath.overrideAttrs {
          pname = name;
          version = if spec ? revision then "0-unstable-${lib.sources.shortRev spec.revision}" else "0";
        };
      }
    ))
  ];
in
{
  appName = "nvim";
  desktopEntry = false;

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
        ];
      };
      impure = toString ./.;
    };

    startAttrs = {
      inherit (sources)
        "conform.nvim"
        "fidget.nvim"
        "guess-indent.nvim"
        "mini.clue"
        "mini.icons"
        "mini.indentscope"
        "mini.pairs"
        "mini.statusline"
        "mini.surround"
        nvim-lspconfig
        nvim-treesitter
        rose-pine
        vim-dirvish
        ;
      # the source will be copied to the store anyway so it's fine
      "+queries" = "${sources.nvim-treesitter}/runtime";
    };

    opt = builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins;
  };
}
