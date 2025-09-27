{
  lib,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,
  libclang,
  clang,
  autoPatchelfHook,

  glib,
  gst_all_1,
  gdk-pixbuf,
  gtk3,
  libusb1,
  libvpx,
  libyuv,
  libaom,
  xdotool,

  libayatana-appindicator,
  libGL,

  waylandSupport ? true,
  wayland,

# add x stuff if you need them
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "legion-kb-rgb";
  version = "0.20.5";

  src = fetchFromGitHub {
    owner = "4JX";
    repo = "L5P-Keyboard-RGB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oWDpLLVLB1PBVEj8dZQyl5tRQvrZv0grH820agCYh/E=";
  };

  cargoHash = "sha256-C3atFrspsmrcAHM/C0jLTBaxOwj6eBtjiiP8SkA5tA0=";

  buildFeatures = [
    "scrap/linux-pkg-config"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    clang
    autoPatchelfHook
  ];

  runtimeDependencies = [
    libayatana-appindicator
    libGL
  ];

  buildInputs = lib.flatten [
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gdk-pixbuf
    gtk3
    libusb1
    libvpx
    libyuv
    libaom
    xdotool
    (lib.optional waylandSupport wayland)
  ];

  LIBCLANG_PATH = "${libclang.lib}/lib";

  meta = {
    description = "Cross platform software to control the RGB/lighting of the 4 zone keyboard included in Lenovo Legion laptops.";
    homepage = "https://github.com/4JX/L5P-Keyboard-RGB";
    changelog = "https://github.com/4JX/L5P-Keyboard-RGB/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux; # windows isn't tested
    mainProgram = "legion-kb-rgb";
  };
})
