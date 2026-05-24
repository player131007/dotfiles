{
  services.kmscon.extraConfig = "font-engine=unifont";

  # FIXME: remove when https://github.com/NixOS/nixpkgs/pull/523569 is merged
  systemd.services."getty.target".enable = false;
  systemd.targets.getty.wants = [ "kmsconvt@tty1.service" ];
  systemd.additionalUpstreamSystemUnits = [
    "getty.target"
    "getty-pre.target"
  ];
}
