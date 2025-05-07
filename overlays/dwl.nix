_: prev:
let
  src = (import ../npins).dwl;
  dwl =
    {
      stdenv,
      lib,
      pkg-config,
      wayland-scanner,
      wayland-protocols,
      libinput,
      wayland,
      wlroots,
      pixman,
      libxkbcommon,
      xwayland,
      libxcb,
      xcbutilwm,
      rootColor ? "0x222222ff",
      borderColor ? "0x444444ff",
      focusColor ? "0x005577ff",
      urgentColor ? "0xff0000ff",
    }:
    stdenv.mkDerivation {
      pname = "dwl";
      version = "unstable-${builtins.substring 0 7 src.revision}";

      inherit src;

      nativeBuildInputs = [
        pkg-config
        wayland-scanner
        wayland-protocols
      ];

      buildInputs = [
        libinput
        wayland
        wlroots
        libxkbcommon
        pixman

        # x11 support
        xwayland
        libxcb
        xcbutilwm
      ];

      postPatch = ''
        sed -Ei "
          ${lib.pipe
            {
              inherit
                rootColor
                borderColor
                focusColor
                urgentColor
                ;
            }
            [
              (lib.mapAttrsToList (name: value: "1,4s/(${lib.toUpper name}).*/\\1 ${value}/"))
              lib.concatLines
            ]
          }
        " config.def.h
      '';

      outputs = [
        "out"
        "man"
      ];

      passthru.providedSessions = [ "dwl" ];

      makeFlags = [
        "WAYLAND_PROTOCOLS=${wayland-protocols}/share/wayland-protocols"
        "WAYLAND_SCANNER=wayland-scanner"
        "PREFIX=$(out)"
        "MANDIR=$(man)/share/man"
      ];

      meta.mainProgram = "dwl";

      strictDeps = true;
      enableParallelBuilding = true;
    };
in
{
  dwl = prev.callPackage dwl { };
}
