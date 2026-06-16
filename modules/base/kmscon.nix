{ myLib, ... }:
{
  disabledModules = [
    "services/ttys/getty.nix"
  ];

  imports = [
    (myLib.fromRoot "modules/delete_me/getty.nix")
  ];

  console.enable = false;
  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    config.libseat = false;
  };
}
