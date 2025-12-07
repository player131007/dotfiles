{
  mnw,
  lib,
  pkgs,
  ...
}:
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
    dev.config = {
      pure =
        (lib.fileset.toSource {
          root = ./.;
          fileset = lib.fileset.unions [
            ./plugin
            ./lua
          ];
        })
        // {
          name = "+config"; # to load the config first
        };
      impure = "~/dots/pkgs/nvim";
    };

    start = mnw.lib.npinsToPlugins pkgs ./start.json;

    opt = builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins;
  };
}
