{
  services.upower = {
    enable = true;
    criticalPowerAction = "PowerOff";
  };
  persist.at.persistdir.directories = [ "/var/lib/upower" ];

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
}
