{
  flake.modules.nixos.pc = {
    services.logind.settings.Login.HandlelidSwitch = "ignore";
  };
}
