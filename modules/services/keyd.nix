{
  flake.modules.nixos.pc = {
    services.keyd = {
      enable = true;
      keyboards.all = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
          };
        };
      };
    };
  };
}
