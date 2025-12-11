{ pkgs, lib, ... }:
let
  release = "v2.2.0";
  url = "https://github.com/rose-pine/gtk/releases/download/${release}";

  rose-pine-theme = pkgs.fetchurl {
    name = "rose-pine-gtk-theme";
    url = "${url}/gtk3.tar.gz";

    downloadToTemp = true;
    recursiveHash = true;
    hash = "sha256-2aK3Onm4F/hsbqndn/WDFHxlXjeDWOMyHO8LfxMe944=";

    postFetch = ''
      mkdir "$TMPDIR/unpack" && cd "$TMPDIR/unpack"
      mv "$downloadedFile" "$TMPDIR/download.tar.gz"
      unpackFile "$TMPDIR/download.tar.gz"

      mkdir -p $out/share/themes
      mv gtk3/rose-pine{,-dawn,-moon}-gtk $out/share/themes
    '';
  };

  rose-pine-icons = pkgs.fetchurl {
    name = "rose-pine-icons";
    url = "${url}/rose-pine-icons.tar.gz";

    downloadToTemp = true;
    recursiveHash = true;
    hash = "sha256-oMj5F08OEFOdQ/zWNVruQ4if68cgcOt2YDb8mInJOFw=";

    postFetch = ''
      mkdir "$TMPDIR/unpack" && cd "$TMPDIR/unpack"
      mv "$downloadedFile" "$TMPDIR/download.tar.gz"
      unpackFile "$TMPDIR/download.tar.gz"

      mkdir -p $out/share
      mv icons $out/share/icons
    '';
  };

  rose-pine-gtk4 = pkgs.fetchurl {
    name = "rose-pine-gtk4";
    url = "${url}/gtk4.tar.gz";

    downloadToTemp = true;
    recursiveHash = true;
    hash = "sha256-IR/I2kRmNEfyy6z3TcG4zA3q23TkdS8Gk/leUnX4ki4=";

    postFetch = ''
      mkdir "$TMPDIR/unpack" && cd "$TMPDIR/unpack"
      mv "$downloadedFile" "$TMPDIR/download.tar.gz"
      unpackFile "$TMPDIR/download.tar.gz"

      mv gtk4 "$out"
    '';
  };
in
{
  environment.systemPackages = [
    rose-pine-theme
    rose-pine-icons
  ];

  programs.dconf.profiles.user = {
    databases = lib.singleton {
      settings = {
        "org/gnome/desktop/interface" = {
          gtk-theme = "rose-pine-gtk";
          icon-theme = "rose-pine-icons";
        };
      };
    };
  };

  my.hjem = {
    xdg.config.files = {
      "gtk-4.0/gtk.css".text = /* css */ ''
        @import "${rose-pine-gtk4}/rose-pine.css";
      '';
    };
  };
}
