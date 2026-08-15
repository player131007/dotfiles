{ inputs, results }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  main = {
    pad = "5x5 center";
    font = builtins.concatStringsSep "," [
      "IosevkaTerm Nerd Font:size=9"
    ];
    include = map (file: "${file}") [
      ./colors.ini
    ];
    dpi-aware = "yes";
    shell = lib.getExe results.fish;
  };
  cursor.blink = "yes";
  colors-dark.alpha = 0.9;
  colors-light.alpha = 0.9;
}
