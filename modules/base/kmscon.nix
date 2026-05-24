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
  services.getty.greetingLine = lib.mkDefault ''<<< Welcome to ${config.system.nixos.distroName} ${config.system.nixos.label} (\m) - \l >>>'';
  services.getty.helpLine = lib.mkIf (
    config.documentation.nixos.enable && config.documentation.doc.enable
  ) "\nRun 'nixos-help' for the NixOS manual.";

  # Friendly greeting on the virtual consoles.
  environment.etc.issue.text = ''

    [1;32m${config.services.getty.greetingLine}[0m
    ${config.services.getty.helpLine}

  '';
}
