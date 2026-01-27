{ config, pkgs, ... }:

# Thanks to this tutorial
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
{
  imports = [
    ./helix.nix
  ];

  home.username = "rowan";
  home.homeDirectory = "/home/rowan";

  # Also set here just in case
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Import files from the current configuration directory into the Nix store,
  # and create symbolic links pointing to those store files in the Home directory.

  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # Import the scripts directory into the Nix store,
  # and recursively generate symbolic links in the Home directory pointing to the files in the store.
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
    # "Xcursor.size" = 16;
    # "Xft.dpi" = 172;
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    brave

    # archives
    zip
    xz
    unzip
    p7zip

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    unixtools.net-tools
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Rowan Torbitzky-Lane";
      user.email = "rowan.a.tl@protonmail.com";
    };
  };

  programs.librewolf = {
    enable = true;
    # Can add extra config here if wanted
    # https://nixos.wiki/wiki/Librewolf
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    # settings = {
      # env.TERM = "xterm-256color";
      # font = {
        # size = 12;
        # draw_bold_text_with_bright_colors = true;
      # };
      # scrolling.multiplier = 5;
      # selection.save_to_clipboard = true;
    # };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
    '';

    # set some aliases, feel free to add more or remove some
    # shellAliases = {
    # };
  };

  # programs.helix = {
  #   enable = true;
  #   settings = {
  #     theme = "gruvbox_light_hard";
  #     editor = {
  #       bufferline = "multiple";
  #       cursorline = true;
  #       end-of-line-diagnostics = "hint";
  #       inline-diagnostics = {
  #         cursor-line = "error";
  #         other-lines = "disable";
  #       };
  #       cursor-shape = {
  #         normal = "block";
  #         select = "underline";
  #       };
  #       indent-guides = {
  #         character = "|";
  #         render = true;
  #       };
  #       statusline.left = ["mode" "spinner" "version-control" "file-name" ];
  #       lsp.display-progress-messages = true;
  #       file-picker.hidden = false;
  #     };
  #     keys = {
  #       normal = {
  #         n = "move_line_down";
  #         N = "join_selections";
  #         A-N = "join_selections_space";
  #         e = "move_line_up";
  #         E = "keep_selections";
  #         A-E = "remove_selections";
  #         i = "move_char_right";
  #         I = "no_op";
          
  #         w = "move_next_word_end";
  #         W = "move_next_long_word_end";
  #         j = "move_next_word_start";
  #         J = "move_next_long_word_start";
  #         k = "search_next";
  #         K = "search_prev";
  #         l = "insert_mode";
  #         L = "insert_at_line_start" ;
  #       };
  #       select = {
  #         i = "extend_char_right";
  #         e = "extend_visual_line_up";
  #         n = "extend_visual_line_down";
  #         E = "extend_line_up"; # what does this do?
  #         N = "extend_line_down";
  #       };
  #     };
  #   };
  #   languages.language = [{
  #     name = "markdown";
  #     auto-pairs = {
  #       "$" = "$";
  #       "(" = "(";
  #       "{" = "}";
  #       "[" = "]";
  #       "<" = ">";
  #     };
  #   }];
  # };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";
}
