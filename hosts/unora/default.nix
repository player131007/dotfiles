{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./apps.nix
  ];

  users.mutableUsers = false;
  users.users.player131007 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "libvirtd"
    ];
    hashedPasswordFile = "/persist/password/player131007";
  };

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  networking = {
    useNetworkd = true;
    dhcpcd.enable = false;
    wireless.iwd.enable = true;
    nameservers = [
      "1.1.1.1#cloudflare-dns.com"
      "2606:4700:4700::1111#cloudflare-dns.com"
      "9.9.9.9#dns.quad9.net"
      "2620:fe::9#dns.quad9.net"
      "8.8.8.8#dns.google"
      "2001:4860:4860::8888#dns.google"
    ];

    firewall = {
      allowedTCPPorts = [ 22000 ]; # syncthing
      allowedUDPPorts = [ 21027 22000 ]; # syncthing
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    fallbackDns = [ ];
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
    networks =
      let
        no-dns = {
          dhcpV4Config.UseDNS = lib.mkForce false;
          dhcpV6Config.UseDNS = lib.mkForce false;
          ipv6AcceptRAConfig.UseDNS = lib.mkForce false;
        };
      in
      {
        "99-ethernet-default-dhcp" = no-dns;
        "99-wireless-client-dhcp" = no-dns;
      };
  };

  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
    shutdownTimeout = 30;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  security = {
    sudo = {
      enable = true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture=never
      '';
    };
  };

  services = {
    # when in doubt: https://wiki.archlinux.org/title/WirePlumber#Delete_corrupt_settings
    pipewire = {
      enable = true;
      alsa.enable = true;
      wireplumber.extraConfig = {
        no-restore-props = {
          "wireplumber.settings" = {
            "node.stream.restore-props" = false;
          };
        };
      };
    };
    greetd = {
      enable = true;
      vt = 2;
      settings.default_session.command = "${lib.getExe pkgs.greetd.tuigreet} -t -d -r --remember-user-session --asterisks --user-menu";
    };
    upower = {
      enable = true;
    };
    fwupd.enable = true;
    logind.lidSwitch = "ignore";
    dbus.implementation = "broker";
    ratbagd.enable = true;
    userborn.enable = true;
  };

  zramSwap.enable = true;

  boot = {
    initrd.systemd.enable = true;
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        edk2-uefi-shell.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  time.timeZone = "Asia/Ho_Chi_Minh";

  console.colors = with config.colorscheme.palette; [
    base01
    base08
    base0B
    base0A
    base0D
    base0E
    base0C
    base06
    base02
    base12
    base14
    base13
    base16
    base17
    base15
    base07
  ];

  preservation =
    let
      mkIf' = cond: content: lib.mkIf cond [ content ];
    in
    {
      enable = true;
      preserveAt = {
        "/persist/once" = {
          commonMountOptions = [ "x-gvfs-hide" ];

          files = [
            {
              file = "/etc/machine-id";
              inInitrd = true;
              how = "symlink"; # is a symlink because we need it to be dangling at first boot
            }
            "/etc/adjtime"
          ];

          directories = lib.mkMerge [
            [
              "/home"
              "/var/lib/nixos"
              "/var/lib/systemd"
              {
                directory = "/nix";
                inInitrd = true;
              }
              {
                directory = "/var/log/journal";
                inInitrd = true;
                group = "systemd-journal";
                mode = "2755";
              }
            ]
            (
              let
                inherit (config.users.users) greeter;
              in
              mkIf' config.services.greetd.enable {
                directory = "/var/cache/tuigreet";
                user = greeter.name;
                group = greeter.group;
              }
            )
          ];
        };

        "/persist/every" = {
          commonMountOptions = [ "x-gvfs-hide" ];

          directories = lib.mkMerge [
            [ "/var/lib/libvirt" ]
            (mkIf' config.networking.wireless.iwd.enable {
              directory = "/var/lib/iwd";
              mode = "0700";
            })
            (mkIf' config.services.upower.enable "/var/lib/upower")
          ];
        };
      };
    };

  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = "/etc/machine-id";
    serviceConfig.ExecStart = "systemd-machine-id-setup --commit --root /persist/once";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # FIXME: fixed in 6.16 and 6.15.4
  boot.kernelPatches = [
    {
      name = "fix-gpu-passthrough";
      patch = ./fix-gpu-passthrough.patch;
    }
  ];

  system.stateVersion = "23.05";
}
