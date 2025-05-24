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
    ./virtualization
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

  nixpkgs.config = {
    cudaSupport = true;
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
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
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

  system.activationScripts = {
    run-nix-index.text = ''
      echo -e '\033[31;1m!!!\033[0m' remember to run nix-index if u updated nixpkgs
    '';
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
    syncthing = {
      enable = true;
      openDefaultPorts = true;
    };
    fwupd.enable = true;
    logind.lidSwitch = "ignore";
    dbus.implementation = "broker";
    ratbagd.enable = true;
  };

  zramSwap.enable = true;

  boot = {
    initrd.systemd.enable = true;
    loader = {
      systemd-boot = {
        enable = true;
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

  # https://nixos.org/manual/nixos/stable/#ch-system-state
  environment.persistence."/persist" = {
    hideMounts = true;
    directories =
      let
        iwd = lib.optional config.networking.wireless.iwd.enable "/var/lib/iwd";
        tuigreet =
          let
            user = config.users.users.greeter;
          in
          lib.optional config.services.greetd.enable {
            directory = "/var/cache/tuigreet";
            user = user.name;
            group = user.group;
          };
        syncthing =
          let
            cfg = config.services.syncthing;
          in
          lib.optional cfg.enable {
            directory = cfg.dataDir;
            inherit (cfg) user group;
          };
        upower = lib.optional config.services.upower.enable "/var/lib/upower";
      in
      lib.concatLists [
        [
          "/var/lib/nixos"
          "/var/lib/systemd"
        ]
        iwd
        tuigreet
        syncthing
        upower
      ];
    files = [
      "/etc/adjtime"
      "/etc/machine-id"
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # FIXME: when this gets merged
  # https://lore.kernel.org/linux-pci/20250313142333.5792-1-ilpo.jarvinen@linux.intel.com
  boot.kernelPatches = [
    {
      name = "fix-gpu-passthrough";
      patch = ./fix-gpu-passthrough.patch;
    }
  ];

  system.stateVersion = "23.05";
}
