{ lib, config, ... }:

{
  options = {
    home-zed.enable
      = lib.mkEnableOption "enable custom zed";  
  };
  
  config = lib.mkIf config.home-zed.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [ "nix" "toml" "rust" "python" ];
      userSettings = {
        helix_mode = true;
        base_keymap = "VSCode";
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        show_edit_predictions = false;
        languages = {
          "Python" = {
            language_servers = [ "ruff" "ty" ];
          };
        };
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
            "g n" = [ "vim::Down" {display_lines = true; } ];
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
