{ lib, config, pkgs, ... }:

{
  options = {
    helix.enable
      = lib.mkEnableOption "enable custom helix";  
  };
  
  programs = lib.mkIf config.helix.enable {
    helix = {
      enable = true;
      settings = {
        theme = "gruvbox_light_hard";
        editor = {
          bufferline = "multiple";
          cursorline = true;
          end-of-line-diagnostics = "hint";
          inline-diagnostics = {
            cursor-line = "error";
            other-lines = "disable";
          };
          cursor-shape = {
            normal = "block";
            select = "underline";
          };
          indent-guides = {
            character = "|";
            render = true;
          };
          statusline.left = ["mode" "spinner" "version-control" "file-name" ];
          lsp.display-progress-messages = true;
          file-picker.hidden = false;
        };
        keys = {
          normal = {
            n = "move_line_down";
            N = "join_selections";
            A-N = "join_selections_space";
            e = "move_line_up";
            E = "keep_selections";
            A-E = "remove_selections";
            i = "move_char_right";
            I = "no_op";
            
            w = "move_next_word_end";
            W = "move_next_long_word_end";
            j = "move_next_word_start";
            J = "move_next_long_word_start";
            k = "search_next";
            K = "search_prev";
            l = "insert_mode";
            L = "insert_at_line_start" ;
          };
          select = {
            i = "extend_char_right";
            e = "extend_visual_line_up";
            n = "extend_visual_line_down";
            E = "extend_line_up"; # what does this do?
            N = "extend_line_down";
          };
        };
      };
      languages.language = [{
        name = "markdown";
        auto-pairs = {
          "$" = "$";
          "(" = "(";
          "{" = "}";
          "[" = "]";
          "<" = ">";
        };
      }];
    };
  };
}
