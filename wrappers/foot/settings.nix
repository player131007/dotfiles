{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
  nushell = inputs.nushell { };
in
{
  main = {
    pad = "5x5 center";
    font = builtins.concatStringsSep "," [
      "IosevkaTerm Nerd Font:size=9"
    ];
    dpi-aware = "yes";
    shell = lib.getExe nushell;
  };
  cursor.blink = "yes";
  colors-dark = {
    alpha = 0.9;

    # vendor the entire theme
    background = "191724";
    foreground = "e0def4";

    regular0 = "26233a";
    regular1 = "eb6f92";
    regular2 = "9ccfd8";
    regular3 = "f6c177";
    regular4 = "31748f";
    regular5 = "c4a7e7";
    regular6 = "ebbcba";
    regular7 = "e0def4";

    bright0 = "47435d";
    bright1 = "ff98ba";
    bright2 = "c5f9ff";
    bright3 = "ffeb9e";
    bright4 = "5b9ab7";
    bright5 = "eed0ff";
    bright6 = "ffe5e3";
    bright7 = "fefcff";

    flash = "f6c177";

    cursor = "191724 e0def4";
  };
  colors-light.alpha = 0.9;
}
