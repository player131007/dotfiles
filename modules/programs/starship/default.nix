{
  pkgs,
  lib,
  ...
}:
let
  starship = lib.getExe pkgs.starship;
  config = ./config.toml;
in
{
  stuff.nushell.vendors = lib.singleton (
    pkgs.runCommandLocal "starship-init-nu" { } ''
      FILE=$out/share/nushell/vendor/autoload/starship.nu

      mkdir -p $(dirname $FILE)
      cat << EOF > $FILE
        export-env {
          \$env.STARSHIP_CONFIG = "${config}"
        }
        $(${starship} init nu)
      EOF
    ''
  );

  programs.bash.interactiveShellInit = /* bash */ ''
    export STARSHIP_CONFIG=${config}
    eval "$(${starship} init bash --print-full-init)"
  '';

  programs.fish.interactiveShellInit = /* fish */ ''
    set -x STARSHIP_CONFIG ${config}
    eval (${starship} init fish)
  '';
}
