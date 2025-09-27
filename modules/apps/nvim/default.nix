{ moduleWithSystem, ... }:
{
  flake.modules.nixos.pc = {
    # FIXME: make this user-specific
    environment.variables.EDITOR = "nvim";
  };

  flake.modules.maid.pc = moduleWithSystem (
    { config, ... }:
    {
      packages = [ config.legacyPackages.neovim ];
      programs.wallust.settings.templates.nvim = {
        template = ./theme.lua;
        target = "~/.config/nvim/colors/wallust.lua";
      };

      # TODO: implement live theme reloader
    }
  );
}
