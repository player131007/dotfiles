{
  flake.modules.nixos.pc = {
    programs.oh-my-posh = {
      enable = true;
      settings = {
        upgrade = {
          notice = false;
          auto = false;
        };
        final_space = true;
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
  };
}
