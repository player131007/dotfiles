{
  flake.modules.nixos.pc = {
    services.logind.lidSwitch = "ignore";
  };
}
