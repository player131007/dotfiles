{
  networking.wireless.iwd.enable = true;
  persist.at.persistdir.directories = [
    {
      directory = "/var/lib/iwd";
      mode = "0700";
    }
  ];
}
