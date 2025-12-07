{
  mnw,
  lib,
  pkgs,
  ...
}:
{
  appName = "nvim";
  desktopEntry = false;

  initLua = /* lua */ ''
    vim.loader.enable() -- enable this asap

    vim.o.exrc = true -- has to be set early

    vim.lsp.config("emmylua_ls", {
      cmd = { "${lib.getExe pkgs.emmylua-ls}" },
    })
    vim.lsp.config("nixd", {
      cmd = { "${lib.getExe pkgs.nixd}" },
    })

    require("conform").formatters = {
      stylua = { command = "${lib.getExe pkgs.stylua}" },
      nixfmt = { command = "${lib.getExe pkgs.nixfmt}" },
    }
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
