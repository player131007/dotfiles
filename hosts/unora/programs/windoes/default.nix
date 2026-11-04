{
  config,
  lib,
  pkgs,
  username,
  wrappers,
  ...
}:
let
  inherit (builtins) readFile;

  nvidia-gpu = "0000:01:00.0";
  nvidia-audio = "0000:01:00.1";
  kvmfr_size_mb = 32;
in
{
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
    kernelModules = [ "kvmfr" ];
    extraModprobeConfig = "options kvmfr static_size_mb=${toString kvmfr_size_mb}";
  };

  services.udev.packages =
    pkgs.writeTextDir "etc/udev/rules.d/70-windoes.rules" ''
      SUBSYSTEM=="vfio", TAG+="uaccess"
      SUBSYSTEM=="kvmfr", TAG+="uaccess"
    ''
    |> lib.singleton;

  # needed for unprivileged gpu passthrough
  security.pam.loginLimits = lib.singleton {
    domain = username;
    type = "-";
    item = "memlock";
    value = "unlimited";
  };

  # makes unplugging gpu easier
  services.kmscon.config.gpus = "primary";
  stuff.niri-config = ''
    debug {
      ignore-drm-device "/dev/dri/by-path/pci-${nvidia-gpu}-render"
    }
  '';

  my.user.packages =
    let
      vfio-helper = pkgs.writeShellScriptBin "vfio-helper" (readFile ./vfio-helper.bash);
      windoes = pkgs.writeShellApplication {
        name = "windoes";
        text = ''
          QEMU=${pkgs.qemu_kvm}
          kvmfr_size=${toString kvmfr_size_mb}
        ''
        + readFile ./windoes.bash;
        inheritPath = false;
        runtimeInputs = [
          pkgs.qemu_kvm
          pkgs.passt
          pkgs.virtiofsd
          "/run/wrappers"
          "/run/current-system/sw" # for systemd
        ];
      };
      windoes-gpu = pkgs.writeShellApplication {
        name = "windoes-gpu";
        text = ''
          gpu=${nvidia-gpu}
          aud=${nvidia-audio}
        ''
        + readFile ./windoes-gpu.bash;
        runtimeInputs = [
          vfio-helper
          windoes
          pkgs.yq
          "/run/current-system/sw" # nvidia-smi and stuff
        ];
      };
    in
    [
      windoes
      windoes-gpu
      wrappers.looking-glass
    ];
}
