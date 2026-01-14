{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.starship = {
    enable = true;
    settings = lib.importTOML ./config.toml;
  };

  stuff.nushell.vendors = lib.singleton (
    pkgs.runCommandLocal "starship-init-nu" { } ''
      mkdir -p $out/share/nushell/vendor/autoload
      echo "\$env.STARSHIP_CONFIG = '${./config.toml}'" > $out/share/nushell/vendor/autoload/starship.nu
      ${lib.getExe config.programs.starship.package} init nu >> $out/share/nushell/vendor/autoload/starship.nu
    ''
  );
}
