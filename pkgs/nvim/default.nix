{
  lib,
  pkgs,
  ...
}:
let
  sources = (import ./lib.nix lib).sources pkgs;

  inherit (pkgs.vimPlugins) nvim-treesitter;
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

    startAttrs =
      lib.mapAttrs
        (
          name: spec:
          if lib.isDerivation spec.outPath then
            spec.outPath.overrideAttrs {
              pname = lib.strings.sanitizeDerivationName name;
              version = if spec ? revision then "0.0.0+rev=${lib.sources.shortRev spec.revision}" else "0";
            }
          else
            spec.outPath
        )
        (sources {
          input = ./npins/plugins.json;
        })
      // {
        "+queries" = "${nvim-treesitter}/runtime";
        inherit nvim-treesitter;
      };

    opt = builtins.attrValues nvim-treesitter.grammarPlugins;
  };
}
