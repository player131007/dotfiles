{
  flake.modules.nixos.pc = {
    services.xserver.xkb.options = "";
    console.useXkbConfig = true;
  };
}
