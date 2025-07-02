{
  ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
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
          skip = 1;
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
        {
          name = "cpp";
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }
      ];
    };
  };
}
