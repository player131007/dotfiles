{
  flake.modules.nixos.pc = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      settings = {
        global.hide_env_diff = true;
      };
    };
  };
}
