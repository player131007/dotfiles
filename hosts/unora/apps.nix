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
      fish.interactiveShellInit = lib.mkBefore "sh ${base24-script}";
      bash.interactiveShellInit = lib.mkBefore "sh ${base24-script}";
      command-not-found.enable = false;
      nix-index.enable = true;
      fish.enable = true;
      ssh.startAgent = true;

      virt-manager.enable = true;
      nano.enable = false;

      oh-my-posh = {
        enable = true;
        settings = {
          upgrade = {
            notice = false;
            auto = false;
          };
          final_space = true;
          pwd = "osc7"; # for foot
          shell_integration = true;
          version = 3;

          blocks = [
            {
              type = "prompt";
              alignment = "left";
              segments = [
                {
                  type = "session";
                  style = "plain";
                  foreground = "default";
                  templates = [
                    "{{ if .SSHSession }} {{ if ne .Env.TERM \"linux\" }} {{ end }}{{ end }}"
                    ''
                      {{- if .Root -}}
                        <red><b>{{ .UserName }}</b></>
                      {{- else -}}
                        <lightBlue>{{ .UserName }}</>
                      {{- end -}}
                    ''
                    "@<lightMagenta>{{ .HostName }}</>"
                  ];
                }
                {
                  type = "path";
                  foreground = "lightYellow";
                  templates = [
                    " {{ .Path }}"
                    "{{ if not .Writable }} <yellow></>{{ end }}"
                  ];
                  properties = {
                    style = "agnoster_short";
                    cycle = [
                      "blue"
                      "cyan"
                      "lightCyan"
                    ];
                    max_depth = 4;
                    display_root = true;
                  };
                }
                {
                  type = "git";
                  style = "plain";
                  foreground = "lightYellow";
                  templates = [
                    " <b>{{ .HEAD }}</b>"
                    "{{ if or .Working.Changed .Staging.Changed }}<lightRed><b>*</b></>{{ end }}"
                    "{{ if .StashCount }} <lightMagenta><b>≡</b></>{{ .StashCount }}{{ end }}"
                    "{{ if .BranchStatus }} {{ .BranchStatus }}{{ end }}"
                  ];
                  properties = {
                    fetch_status = true;
                    fetch_stash_count = true;

                    branch_icon = "<lightBlue></>";
                    branch_identical_icon = "";
                    branch_ahead_icon = "<16> </>";
                    branch_behind_icon = "<16> </>";
                    branch_gone_icon = "";

                    commit_icon = "<lightBlue> </>";
                    tag_icon = "<lightBlue> </>";
                    rebase_icon = "<lightBlue> </> ";
                    cherry_pick_icon = "<lightBlue> </> ";
                    revert_icon = "<lightBlue> </> ";
                    merge_icon = "<lightBlue> </> ";
                  };
                }
              ];
            }
            {
              type = "prompt";
              alignment = "right";
              overflow = "break";
              segments = [
                {
                  type = "status";
                  style = "plain";
                  foreground = "default";
                  properties = {
                    status_template = ''
                      {{- if .Code -}}
                        <red><b>{{ reason .Code }}</b></>
                      {{- else -}}
                        <green>{{ reason .Code }}</>
                      {{- end -}}
                    '';
                    status_separator = " | ";
                  };
                }
                {
                  type = "executiontime";
                  style = "plain";
                  foreground = "16";
                  template = "  {{ .FormattedMs }}";
                  properties = {
                    threshold = 2000;
                    style = "austin";
                  };
                }
                {
                  type = "text";
                  style = "plain";
                  foreground = "magenta";
                  template = "{{ if gt .SHLVL 1 }}  {{ .SHLVL }}{{ end }}";
                }
              ];
            }
            {
              type = "prompt";
              alignment = "left";
              newline = true;
              segments = [
                {
                  type = "text";
                  style = "plain";
                  foreground = "green";
                  foreground_templates = [ "{{ if .Code }}red{{ end }}" ];
                  template = "<b>❯</b>";
                }
              ];
            }
          ];
        };
      };

      git = {
        enable = true;
        config = {
          core = {
            autocrlf = "input";
            pager = "${lib.getExe pkgs.diff-so-fancy} | less -+X -FR --use-color";

            compression = 9;
          };

          color = {
            diff-highlight = {
              oldNormal = "red bold";
              oldHighlight = "red bold reverse";
              newNormal = "green bold";
              newHighlight = "green bold reverse";
            };

            diff = {
              meta = "white";
              frag = "magenta bold";
              whitespace = "17 reverse";
              commit = "yellow";
              old = "red bold";
              new = "green bold";
            };
          };

          diff = {
            renames = "copies";
            interHunkContext = 10;
          };

          log = {
            date = "relative";
            graphColors = "blue,yellow,cyan,magenta,green,red";
          };

          url = {
            "git@github.com:player131007/".insteadOf = [ "me:" ];
            "https://github.com/".insteadOf = [
              "gh:"
              "github:"
            ];
            "git@github.com:".pushInsteadOf = [ "https://github.com/" ];
          };

          interactive = {
            diffFilter = "${lib.getExe pkgs.diff-so-fancy} --patch";
            singlekey = true;
          };
          diff-so-fancy.markEmptyLines = false;
          status = {
            branch = true;
            showStash = true;
          };
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
      # less doesn't support coloring text formatted with ANSI escape sequences
      MANROFFOPT = "-P-c";
      MANPAGER = "less -Rs --use-color -Dd+y -Du+b";
    })
  ];

  environment.systemPackages = with pkgs; [
    piper

    eza

    man-pages
    diff-so-fancy
  ];

  environment.shellAliases = {
    ls = "eza --icons -F";
    ll = "eza --icons -F -lhb";
    l = "eza --icons -F -lhba";
    gs = "git status --short";
    ga = "git add";
    gaa = "git add -A";
    gc = "git commit";
    gd = "git diff";
    gp = "git push";
    gl = "git log --all --graph --pretty=format:'%C(brightcyan)%h  %C(white)%an  %C(yellow)%ad %C(auto)%D%n%s%n'";
  };
}
