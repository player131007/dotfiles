{ config, inputs, lib, ... }: {
    imports = [
        inputs.nixvim.homeManagerModules.nixvim
    ];

    home.sessionVariables = { EDITOR = "nvim"; };
    programs.nixvim = {
        enable = true;
        luaLoader.enable = true;

        clipboard.providers.wl-copy.enable = true;
        colorschemes.base16 = {
            enable = true;
            customColorScheme = lib.filterAttrs (name: _: builtins.elem name (map (x: "base0${x}") (lib.stringToCharacters "0123456789ABCDEF"))) config.scheme.withHashtag;
        };
        plugins.lualine.enable = true;

        clipboard.register = "unnamedplus";
        options = {
            relativenumber = true;
            number = true;
            tabstop = 4;
            shiftwidth = 4;
            expandtab = true;
            autoindent = true;
            wrap = false;
            ignorecase = true;
            smartcase = true;
            backspace = "indent,eol,start";
            splitright = true;
            splitbelow = true;
            completeopt = "menu,menuone,noselect";
            list = true;
            listchars = {
                trail = "·";
                multispace = "‣···";
                tab = "‣ ";
            };
        };

        globals.mapleader = " ";
        keymaps = let
            normalKey = key: action: {
                mode = "n";
                inherit key action;
            };
        in lib.mapAttrsToList normalKey {
            "<leader>nh" = "<cmd>nohl<CR>";
            "<leader>sv" = "<C-w>v";
            "<leader>sh" = "<C-w>s";
            "<C-h>" = "<C-w>h";
            "<C-j>" = "<C-w>j";
            "<C-k>" = "<C-w>k";
            "<C-l>" = "<C-w>l";
            "<leader>xd" = { __raw = "function() require(\"trouble\").toggle(\"document_diagnostics\") end"; };
            "<leader>gr" = { __raw = "function() require(\"trouble\").toggle(\"lsp_references\") end"; };
            "<leader>gd" = { __raw = "function() require(\"trouble\").toggle(\"lsp_definitions\") end"; };
            "<leader>td" = { __raw = "function() require(\"trouble\").toggle(\"lsp_type_definitions\") end"; };
        };

        plugins = {
            lsp = {
                enable = true;
                keymaps = {
                    diagnostic = {
                        "[d" = "goto_prev";
                        "]d" = "goto_next";
                    };
                    lspBuf = {
                        "<leader>gD" = "declaration";
                        "K" = "hover";
                        "<F2>" = "rename";
                        "<leader>ca" = "code_action";
                    };
                };
                servers = {
                    clangd = {
                        enable = true;
                        cmd = [ "clangd" "-j" "4" "--malloc-trim" "--pch-storage=memory" "--header-insertion=never" ];
                    };
                    nil_ls = {
                        enable = true;
                        extraOptions.settings = {
                            nil.nix.flake.autoArchive = true;
                        };
                    };
                };
            };

            nvim-autopairs = {
                enable = true;
                checkTs = true;
            };

            treesitter = {
                enable = true;
                indent = true;
            };

            comment-nvim = {
                enable = true;
                padding = true;
            };

            luasnip = {
                enable = true;
                extraConfig = {
                    update_events = [ "TextChanged" "TextChangedI" ];
                };
                fromLua = [
                    { paths = "${./snippets}"; }
                ];
            };

            cmp = {
                enable = true;
                settings = {
                    snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
                    sources = [
                        { name = "luasnip"; }
                        { name = "nvim_lsp"; }
                        { name = "nvim_lsp_signature_help"; }
                    ];
                    mapping = {
                        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
                        "<C-f>" = "cmp.mapping.scroll_docs(4)";
                        "<C-e>" = "cmp.mapping.abort()";
                        "<Tab>" = ''
                            function(fallback)
                                local luasnip = require "luasnip"
                                if cmp.visible() then cmp.select_next_item()
                                elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                                else fallback()
                                end
                            end
                        '';
                        "<S-Tab>" = ''
                            function(fallback)
                                local luasnip = require "luasnip"
                                if cmp.visible() then cmp.select_prev_item()
                                elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                                else fallback()
                                end
                            end
                        '';
                        "<CR>" = ''
                            cmp.mapping {
                                i = function(fallback)
                                    if cmp.visible() and cmp.get_active_entry() then
                                        cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
                                    else fallback()
                                    end
                                end,
                                s = cmp.mapping.confirm { select = true }
                            }
                        '';
                    };
                };
            };
            trouble.enable = true;
        };
    };
}
