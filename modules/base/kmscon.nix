{ config, lib, ... }:
{
  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    term =
      lib.warnIf (lib.versionOlder "9.3.5" config.services.kmscon.package.version)
        "kmscon >9.3.5 has TERM set properly by default, no need to approximate"
        "xterm-256color";
  };

  console.enable = false;

  environment.etc.issue.text = ''

    [1;32m<<< Welcome to ${config.system.nixos.distroName} ${config.system.nixos.label} (\m) - \l >>>[0m
    ${lib.optionalString (
      config.documentation.nixos.enable && config.documentation.doc.enable
    ) "\nRun 'nixos-help' for the NixOS manual."}

  '';
}
