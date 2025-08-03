{
  flake.modules.nixos.pc = {
    # FIXME: make this user-specific
    environment.variables = {
      EDITOR = "hx";
    };
  };

  flake.modules.maid.pc = {
    programs.helix = {
      enable = true;
      settings = {
        theme = "base16_transparent";
        editor = {
          line-number = "relative";
          mouse = false;
          middle-click-paste = false;
          popup-border = "popup";
          color-modes = true;
          bufferline = "multiple";

          lsp = {
            display-messages = true;
            display-progress-messages = true;
          };
          cursor-shape.insert = "bar";
          indent-guides = {
            render = true;
            character = "▏";
            skip-levels = 1;
          };
        };

        keys = {
          normal = {
            tab = "move_parent_node_end";
            S-tab = "move_parent_node_start";
          };

          insert = {
            S-tab = "move_parent_node_start";
          };

          select = {
            tab = "extend_parent_node_end";
            S-tab = "extend_parent_node_start";
          };
        };
      };

      languages = {
        language-server = {
          clangd.args = [
            "--log=error"
            "--header-insertion=never"
            "--header-insertion-decorators=false"
            "-j"
            "8"
            "--malloc-trim"
            "--pch-storage=memory"
          ];

          nixd.args = [
            "--log=error"
          ];
        };

        language = [
          {
            name = "nix";
            language-servers = [ "nixd" ];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }
        ];
      };
    };
  };
}
