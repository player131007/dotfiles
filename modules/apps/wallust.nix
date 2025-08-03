{
  flake.modules.maid.pc = {
    programs.wallust = {
      enable = true;
      settings = {
        backend = "full";
        color_space = "lch";
        palette = "dark16";
        fallback_generator = "interpolate";
      };
    };
  };
}
