{
  flake.modules.nixos.base =
    { lib, config, ... }:
    {
      environment.variables = lib.mkIf config.documentation.man.enable {
        # less doesn't support coloring text formatted with ANSI escape sequences
        MANROFFOPT = "-P-c";
        MANPAGER = "less -Rs --use-color -Dd+y -Du+b";
      };
    };

  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.man-pages ];
    };
}
