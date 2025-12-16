{
  lib,
  pkgs,
  ...
}:
let
  sources = import ./npins/pkgs-fetcher.nix pkgs;
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
        ;
      # the source will be copied to the store anyway so it's fine
      "+queries" = "${sources.nvim-treesitter}/runtime";
    };

    opt = builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins;
  };
}
