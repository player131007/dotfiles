{
  services.upower = {
    enable = true;
    criticalPowerAction = "PowerOff";
  };
  persist.at.persistdir.directories = [ "/var/lib/upower" ];

  services.power-profiles-daemon.enable = true;
  persist.at.oncedir.directories = [ "/var/lib/power-profiles-daemon" ];

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
}
