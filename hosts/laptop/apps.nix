{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs = {
    command-not-found.enable = false;
    nix-index.enable = true;
    fish.enable = true;
    ssh.startAgent = true;

    virt-manager.enable = true;
    nano.enable = false;

    git = {
      enable = true;
      config = {
        core = {
          autocrlf = "input";
          pager = "less -FRX";

          compression = 9;
          whitespace = "error";
        };
        status.showStash = true;
        commit.verbose = true;
      };
    };
  };

  environment.variables = lib.mkMerge [
    (lib.mkIf config.documentation.man.enable {
      MANROFFOPT = "-P-c";
      MANPAGER = "less -s -Dd+y -Du+b";
    })
    (lib.mkIf config.programs.less.enable {
      LESS = "-R --use-color";
    })
  ];

  stuffs.oh-my-posh = {
    enable = true;
    configFile = ./pure.omp.toml;
  };

  stuffs.dwl = {
    enable = true;
    package =
      with config.scheme;
      pkgs.dwl.override {
        rootColor = "0x${base00}ff";
        borderColor = "0x${base02}ff";
        focusColor = "0x${base14}ff";
        urgentColor = "0x${base12}ff";
      };
    envVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
    };

    startupCommand = "$HOME/.config/startup";
  };

  environment.systemPackages = with pkgs; [
    piper

    eza

    man-pages
  ];

  environment.shellAliases = {
    ls = "eza --icons -F";
    ll = "eza --icons -F -lhb";
    l = "eza --icons -F -lhba";
    vm = ''
      sudo rm /windows/win10.qcow2;
      sudo qemu-img create -b /windows/base.qcow2 -F qcow2 -f qcow2 -o compression_type=zstd,nocow=on /windows/win10.qcow2 && \
      virsh --connect qemu:///system start win10 \
    '';
    vm2 = "looking-glass-client input:rawMouse=true spice:captureOnStart=true -F -m KEY_INSERT";
  };
}
