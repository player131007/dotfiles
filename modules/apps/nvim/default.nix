{ moduleWithSystem, ... }:
{
  flake.modules.nixos.pc = {
    # FIXME: make this user-specific
    environment.variables.EDITOR = "nvim";
  };

  flake.modules.maid.pc = moduleWithSystem (
    { inputs', ... }:
    { config, ... }:
    {
      packages = [ inputs'.nvim-flake.packages.neovim ];
      programs.wallust.settings.templates.nvim = {
        template = ./theme.lua;
        target = "~/.config/nvim/colors/wallust.lua";
      };

      file.xdg_config."nvim/plugin/wallust-reload.lua".text = # lua
        ''
          if not vim.g.loaded_theme_watcher then
            vim.g.loaded_theme_watcher = true
            local path = ${builtins.toJSON config.programs.wallust.settings.templates.nvim.target}
            local watch, debounce = assert(vim.uv.new_fs_event()), nil
            local function on_change()
              if debounce then return end
              debounce = vim.defer_fn(function()
                debounce = nil
                vim.cmd "colorscheme wallust"

                watch:start(path, {}, on_change)
              end, 50)

              watch:stop()
            end

            watch:start(path, {}, on_change)
          end
        '';
    }
  );
}
