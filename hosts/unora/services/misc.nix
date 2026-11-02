{
  config,
  lib,
  pkgs,
  ...
}:
{
  fonts.packages = [ pkgs.nerd-fonts.iosevka-term ];

  services = {
    dbus.implementation = "broker";
    flatpak.enable = true;
    fwupd.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
    };
    kmscon.config = {
      hwaccel = true;
      font-name = "IosevkaTerm Nerd Font";
    };
    userborn = {
      enable = true;
      importLegacyState = false;
    };
  };

  persist.at = {
    oncedir.directories = lib.mkIf config.services.fwupd.enable [ "/var/lib/fwupd" ];
    persistdir.directories =
      lib.singleton {
        directory = "/var/lib/iwd";
        mode = "0700";
      }
      |> lib.mkIf config.networking.wireless.iwd.enable;
  };
}
