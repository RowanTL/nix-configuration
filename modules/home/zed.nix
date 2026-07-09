{ lib, config, pkgs, ... }:

let
  shadesOfPurpleRepo = pkgs.fetchFromGitHub {
    owner = "irmhonde";
    repo = "shades-of-purple-theme";
    rev = "92840e17621cbdc4ca05e7c108c104a369354815";
    hash = "sha256-ro03rp0tHeR7H2PRZayc64Tw4llUOLxqfTOTUHwbKbM=";
  };
in
{
  options = {
    home-zed.enable
      = lib.mkEnableOption "enable custom zed";  
  };
  
  config = lib.mkIf config.home-zed.enable {
    programs.zed-editor = {
      enable = true;
      extraPackages = with pkgs; [
        ruff
        ty
        # python3
        nixd
        claude-agent-acp
        claude-code
      ];
      extensions = [
        "nix"
        "toml"
        "rust"
        "python"
        "nu"
        "asciidoc"
        "gdscript"
        "astro"
        "lean4"
      ];
      userSettings = {
        helix_mode = true;
        base_keymap = "VSCode";
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        show_edit_predictions = false;
        languages = {
          Python = {
            language_servers = [ "ruff" "ty" "!basedpyright" ];
            format_on_save = "on";
            formatter = "language_server";
          };
        };
        terminal = {
          "shell" = {
            "program" = lib.getExe pkgs.nushell;
          };
        };
        agent_servers = {
          "claude-code" = {
            type = "custom";
            command = lib.getExe pkgs.claude-agent-acp;
            env = {};
          };
        };
        language_models = {
          google = {
            available_models = [
              {
                name = "gemini-2.5-flash";
                display_name = "Gemini 2.5 Flash";
                max_tokens = 1048576;
              }
              {
                name = "gemini-2.5-flash-lite";
                display_name = "Gemini 2.5 Flash-Lite";
                max_tokens = 1048576;
              }
              {
                name = "gemini-2.5-pro";
                display_name = "Gemini 2.5 Pro";
                max_tokens = 1048576;
              }
              {
                name = "gemini-3-flash";
                display_name = "Gemini 3 Flash-Lite";
                max_tokens = 1048576;
              }
              {
                name = "gemini-3.1-flash-lite";
                display_name = "Gemini 3.1 Flash-Lite";
                max_tokens = 1048576;
              }
              {
                name = "gemini-3.1-pro";
                display_name = "Gemini 3.1 Pro";
                max_tokens = 1048576;
              }
              {
                name = "gemini-3.5-flash";
                display_name = "Gemini 3.5 Flash";
                max_tokens = 1048576;
              }
              {
                name = "gemma-4-31b-it";
                display_name = "Gemma 4 31B";
                max_tokens = 256000;
              }
            ];
          };
        };
      };
      themes = {
        shades-of-purple-theme = builtins.fromJSON ( builtins.readFile "${shadesOfPurpleRepo}/themes/shades-of-purple-theme.json" );
      };
      userKeymaps = [
        {
          context = "(VimControl && !menu)";
          bindings = {
            e = "vim::Up";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            f = "vim::NextWordEnd";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            t = [ "vim::PushFindForward" { before = false; multiline = false; } ];
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "g e" = [ "vim::Up" { display_lines = true; } ];
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "g f" = "vim::PreviousWordEnd";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "g t" = "editor::OpenSelectedFilename";
          };
        }
        {
          context = "((vim_mode == helix_normal || vim_mode == helix_select) && !menu)";
          bindings = {
            "g n" = "pane::ActivateNextItem";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            n = "vim::Down";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            k = "vim::MoveToNextMatch";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            K = "vim::MoveToPreviousMatch";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "g k" = "vim::SelectNextMatch";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            i = "vim::Right";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            j = null;
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "g j" = null;
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            ctrl-n = "vim::Down";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            ctrl-j = null;
          };
        }
        {
          context = "(vim_mode == helix_normal && !menu)";
          bindings = {
            l = "vim::HelixInsert";
          };
        }
        {
          context = "(vim_mode == helix_normal && !menu)";
          bindings = {
            i = "vim::WrappingRight";
          };
        }
        {
          context = "vim_mode == normal";
          bindings = {
            l = "vim::InsertBefore";
          };
        }
        {
          context = "(vim_mode == helix_normal && !menu)";
          bindings = {
            "g e" = "vim::EndOfDocument";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "g d" = "editor::GoToDefinition";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "g shift-d" = "editor::GoToDeclaration";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "ctrl-w g d" = "editor::GoToDefinitionSplit";
          };
        }
        {
          context = "(VimControl && !menu)";
          bindings = {
            "ctrl-w g shift-d" = "editor::GoToTypeDefinitionSplit";
          };
        }
        {
          context = "vim_mode == visual";
          bindings = {
            shift-l = "vim::InsertBefore";
          };
        }
        {
          context = "((vim_mode == normal || vim_mode == helix_normal) && !menu)";
          bindings = {
            shift-l = "vim::InsertFirstNonWhitespace";
          };
        }
        {
          context = "((vim_mode == normal || vim_mode == helix_normal) && !menu)";
          bindings = {
            shift-i = null;
          };
        }
        {
          context = "vim_mode == visual";
          bindings = {
            shift-i = null;
          };
        }
        {
          context = "(VimControl || (!Editor && !Terminal))";
          bindings = {
            "ctrl-w i" = "workspace::ActivatePaneRight";
          };
        }
        {
          context = "(VimControl || (!Editor && !Terminal))";
          bindings = {
            "ctrl-w l" = null;
          };
        }
        {
          context = "(VimControl || (!Editor && !Terminal))";
          bindings = {
            "ctrl-w n" = "workspace::ActivatePaneDown";
          };
        }
        {
          context = "(VimControl || (!Editor && !Terminal))";
          bindings = {
            "ctrl-w j" = null;
          };
        }
        {
          context = "(VimControl || (!Editor && !Terminal))";
          bindings = {
            "ctrl-w k" = "workspace::NewFileSplitHorizontal";
          };
        }
        {
          context = "(VimControl || (!Editor && !Terminal))";
          bindings = {
            "ctrl-w e" = "workspace::ActivatePaneUp";
          };
        }
        {
          context = "((vim_mode == helix_normal || vim_mode == helix_select) && !menu)";
          bindings = {
            "g p" = "pane::ActivatePreviousItem";
          };
        }
      ];
    };
  };
}
