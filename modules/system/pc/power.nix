{
  services.upower = {
    enable = true;
    criticalPowerAction = "PowerOff";
  };
  persist.at.persistdir.directories = [ "/var/lib/upower" ];

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    pd.enable = true;
  };
  persist.at.oncedir.directories = [ "/var/lib/tlp" ];

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
}
