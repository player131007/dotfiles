{ myLib, ... }:
{
  disabledModules = [
    "services/ttys/kmscon.nix"
    "services/ttys/getty.nix"
    "config/console.nix"
  ];

  imports = map (f: myLib.fromRoot "modules/delete_me/${f}") [
    "kmscon.nix"
    "getty.nix"
    "console.nix"
  ];

  console.enable = false;
  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    config.libseat = false;
  };
}
