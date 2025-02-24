_: prev: let
  rev = "b15714b38a1ed58196046d4365c45e85f552a8ce";
  yambar = (prev.yambar.override {x11Support = false;}).overrideAttrs (prevAttrs: {
    version = "1.12.0-dev-${builtins.substring 0 8 rev}";

    src = prev.fetchFromGitea {
      domain = "codeberg.org";
      owner = "dnkl";
      repo = "yambar";
      inherit rev;
      hash = "sha256-cJsGNf2/7+n5us+XEA9TC01h4Yj2oIDxmHEldMQ//aY=";
    };

    mesonFlags =
      prevAttrs.mesonFlags
      or []
      ++ [
        (prev.lib.mesonEnable "plugin-xkb" false)
      ];
  });
in {
  inherit yambar;
}
