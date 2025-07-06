{
  flake.modules.nixos.pc = {
    services.dbus.implementation = "broker";
  };
}
