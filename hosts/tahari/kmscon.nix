{
  services.kmscon.extraConfig = "font-engine=unifont";

  # fix bug in kmscon module
  systemd.services."getty.target".enable = false;
  systemd.targets.getty.wants = [ "kmsconvt@tty1.service" ];
  systemd.additionalUpstreamSystemUnits = [
    "getty.target"
    "getty-pre.target"
  ];
}
