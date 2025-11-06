{
  pkgs,
  config,
  my,
  ...
}:
let
  extra-config = "${config.hjem.users.${my.name}.xdg.config.directory}/qutebrowser/extra.py";
in
{
  fonts.packages = [
    pkgs.inter
    pkgs.iosevka
  ];

  my.tmpfiles.rules = [ "f ${extra-config} - - -" ];

  my.hjem = {
    packages = [ pkgs.qutebrowser ];
    xdg.config.files."qutebrowser/config.py".text = /* python */ ''
      config.load_autoconfig() # can't do this in any other file

      c.fonts.tabs.selected = "500 12pt Inter Display"
      c.fonts.tabs.unselected = "500 12pt Inter Display"
      c.fonts.statusbar = "400 10.5pt Iosevka"
      c.fonts.completion.category = "bold 11pt Iosevka"
      c.fonts.completion.entry = "400 10.5pt Iosevka"

      config.source("${extra-config}")
    '';
  };
}
