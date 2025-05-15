{
  pkgs,
  lib,
  config,
  npins,
  ...
}:
{
  programs =
    let
      base24-script = config.colorscheme {
        template = "${npins.tinted-shell}/templates/base24.mustache";
        extension = "sh";
      };
    in
    {
      fish.interactiveShellInit = lib.mkAfter "sh ${base24-script}";
      bash.interactiveShellInit = lib.mkAfter "sh ${base24-script}";
      bash.promptInit = lib.mkBefore ''
        # foot shell integration
        osc7_cwd() {
          local strlen=''${#PWD}
          local encoded=""
          local pos c o
          for (( pos=0; pos<strlen; pos++ )); do
              c=''${PWD:$pos:1}
              case "$c" in
                  [-/:_.!\'\(\)~[:alnum:]] ) o="''${c}" ;;
                  * ) printf -v o '%%%02X' "''\'''${c}" ;;
              esac
              encoded+="''${o}"
          done
          printf '\e]7;file://%s%s\e\\' "''${HOSTNAME}" "''${encoded}"
        }

        prompt_marker() {
          printf '\e]133;A\e\\'
        }

        command_done() {
            printf '\e]133;D\e\\'
        }

        PS0+='\e]133;C\e\\'
        PROMPT_COMMAND=(command_done prompt_marker osc7_cwd)
      '';
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

          pager.diff = "diff-so-fancy | $PAGER";
          diff-so-fancy.markEmptyLines = false;
          color.diff = {
            meta = "black bold";
            frag = "magenta";
            whitespace = "yellow reverse";
          };
          status.showStash = true;
          commit.verbose = true;
        };
      };

      river = {
        enable = true;
        extraPackages = [ ];
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

  environment.systemPackages = with pkgs; [
    piper

    eza

    man-pages
    diff-so-fancy # for git
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
