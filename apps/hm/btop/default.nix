{
    programs.btop.enable = true;
    programs.btop.settings = {
        theme_background = false;
        truecolor = true;
        update_ms = 1000;
        disks_filter = "exclude=/persist /var/log /etc/NetworkManager/system-connections";
    };
}
