{
  pkgs,
  config,
  lib,
  ...
}: {
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

  networking = {
    hostName = "laptop";

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
    fallbackDns = [];
  };

  # it keeps trying to save /etc/machine-id
  systemd.services.systemd-machine-id-commit.enable = false;

  systemd.network = {
    enable = true;
    wait-online.enable = false;
    networks = let
      no-dns = {
        dhcpV4Config.UseDNS = lib.mkForce false;
        dhcpV6Config.UseDNS = lib.mkForce false;
        ipv6AcceptRAConfig.UseDNS = lib.mkForce false;
      };
    in {
      "99-ethernet-default-dhcp" = no-dns;
      "99-wireless-client-dhcp" = no-dns;
    };
  };

  system.activationScripts = {
    run-nix-index.text = ''
      echo -e '\033[31;1m!!!\033[0m' remember to run nix-index if u updated nixpkgs
    '';

    diff-current-gen = {
      supportsDryActivation = true;
      text = ''
        if [[ -e /run/current-system ]]; then
          echo "=== diff to current-system ==="
          ${pkgs.nvd}/bin/nvd --nix-bin-dir='${config.nix.package}/bin' diff /run/current-system "$systemConfig"
          echo "=== end of the system diff ==="
        fi
      '';
    };
  };

  console.colors = with config.scheme; [
    base00
    base08
    base0B
    base0A
    base0D
    base0E
    base0C
    base05
    base11
    base12
    base14
    base13
    base16
    base17
    base15
    base07
  ];

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
    pipewire = {
      enable = true;
      alsa.enable = true;
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
      systemd-boot.enable = true;
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

  time.timeZone = "Asia/Ho_Chi_Minh";

  # https://nixos.org/manual/nixos/stable/#ch-system-state
  environment.persistence."/persist" = let
    getEnableOption = parts: lib.foldl' (acc: x: acc.${x}) config (parts ++ ["enable"]);
  in {
    hideMounts = true;
    directories =
      [
        "/var/lib/nixos"
        "/var/lib/systemd"
      ]
      ++ lib.optional (getEnableOption [
        "networking"
        "wireless"
        "iwd"
      ]) "/var/lib/iwd"
      ++ lib.optional
      (getEnableOption [
        "services"
        "greetd"
      ])
      {
        directory = "/var/cache/tuigreet";
        user = "greeter";
        group = "greeter";
      }
      ++ lib.optional
      (getEnableOption [
        "services"
        "syncthing"
      ])
      (
        with config.services.syncthing; {
          directory = dataDir;
          inherit user group;
        }
      );
    files = [
      "/etc/adjtime"
      "/etc/machine-id"
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  system.stateVersion = "23.05";
}
