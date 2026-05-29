{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        options = {
          shada = "!,'100,<50,s10,h";
          undofile = true;

          # Настройки отступов
          autoindent = true; # Копировать отступ с текущей строки на новую
          smartindent = true; # Умный отступ для C-подобных языков (добавляет отступ после { и т.д.)
          expandtab = true; # Заменять Tab на пробелы (обязательный стандарт для Nix, YAML, Python)
          shiftwidth = 2; # Количество пробелов для каждого шага отступа (можно изменить на 4)
          tabstop = 2; # Визуальная ширина символа Tab
        };

        # Подключение внешних плагинов
        extraPlugins = with pkgs.vimPlugins; {
          yazi-nvim = {
            package = yazi-nvim;
            setup = "require('yazi').setup()";
          };
          telescope-zoxide = {
            package = telescope-zoxide;
            setup = "require('telescope').load_extension('zoxide')";
          };
        };

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          bash.enable = true;
          typescript.enable = true;
          html.enable = true;
          css.enable = true;
          python = {
            enable = true;
            dap.enable = true;
          };
          rust = {
            enable = true;
            dap.enable = true;
            extensions.crates-nvim.enable = true;
          };
          nix.enable = true;
          lua.enable = true;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
          presets.tailwindcss-language-server.enable = true;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        snippets.luasnip.enable = true;
        treesitter.enable = true;
        autopairs.nvim-autopairs.enable = true;

        maps = {
          normal = {
            "<leader>e" = {
              action = "<cmd>Neotree toggle<CR>";
              desc = "Toggle File Tree";
            };
          };
        };

        assistant.codecompanion-nvim = {
          enable = true;
          setupOpts = {
            interactions = {
              chat.adapter = "anthropic";
              inline.adapter = "anthropic";
            };
          };
        };

        binds.whichKey.enable = true;
        filetree.neo-tree.enable = true;
        git.enable = true;

        visuals = {
          nvim-web-devicons.enable = true;
          # Правильное объявление внутри visuals
          indent-blankline = {
            enable = true;
            setupOpts = {
              exclude = {
                filetypes = ["dashboard"];
              };
            };
          };
        };

        # dashboard находится на одном уровне с visuals, а не внутри него
        dashboard.dashboard-nvim = {
          enable = true;
          setupOpts = {
            theme = "doom";
            config = {
              footer = [""];
              header = [
                ""
                ""
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⠃⠀⣠⣶⣾⣿⣷⢶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢷⣦⣷⣶⣾⣿⣿⣿⣿⣿⠉⠉⠛⠓⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⣿⣿⣿⣿⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣿⡆⠀⢹⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⢻⡀⣾⣿⣿⣿⣿⠉⠙⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⢿⣿⣿⣿⣆⢀⣴⣾⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣩⡏⠘⣿⣿⣿⣿⣿⢿⣿⣿⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠟⠀⠀⣸⣿⣿⣿⣿⣦⣽⣃⣉⣛⣛⣛⡯⠍⠀⠀⢀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀"
                "⣶⣶⣶⣶⣦⣤⣤⣤⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⢀⣼⡏⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣂⠀⠀⠀"
                "⠀⠉⠙⠻⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣷⣄"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢼⣿⣿⣿⣿⡿⣿⢿⣿⣿⡏⠛⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠆"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⢸⡏⢿⣿⠀⠀⠀⠀⠉⠙⠛⠛⠿⠿⠿⣿⣿⣿⣿⣿⣿⡿⠛⠯⠃"
                "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠃⠘⠿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠉⠛⠋⠀⠀⠀⠀"
                ""
              ];
              center = [
                {
                  action = "Telescope find_files";
                  desc = " Find Files";
                  icon = " ";
                  key = "f";
                }
                {
                  action = "ene";
                  desc = " New File";
                  icon = " ";
                  key = "n";
                }
                {
                  action = "Telescope live_grep";
                  desc = " Find Text";
                  icon = " ";
                  key = "g";
                }
                {
                  action = "Telescope oldfiles";
                  desc = " Recent Files";
                  icon = " ";
                  key = "r";
                }
                {
                  action = "Yazi";
                  desc = " Yazi File Manager";
                  icon = "󰇥 ";
                  key = "y";
                }
                {
                  action = "Telescope zoxide list";
                  desc = " Zoxide (Recent Dirs)";
                  icon = " ";
                  key = "z";
                }
                {
                  action = "qa";
                  desc = " Quit";
                  icon = " ";
                  key = "q";
                }
              ];
            };
          };
        };

        utility = {
          surround.enable = true;
          yanky-nvim.enable = true;
        };
      };
    };
  };

  programs = {
    lazygit.enable = true;
    ripgrep.enable = true;
  };
}
