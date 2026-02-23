{ lib, config, pkgs, ... }:

# Thanks to this tutorial
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
{
  imports = [
    ./../../modules/home
    ./../../modules/home/helix.nix
    ./../../modules/home/git.nix
    ./../../modules/home/ssh.nix
    ./../../modules/home/sway.nix
    ./../../modules/home/zed.nix
  ];

  home.username = "rowan";
  home.homeDirectory = "/home/rowan";
  
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

  # Enable my custom configs
  # others are enabled in modules/home/default.nix
  home-sway.enable = true;
  home-zed.enable = true;

  # need to scale my stuff
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "main";
          outputs = [
            {
              criteria = "eDP-1";
              scale = 1.1;
              status = "enable";
            }
          ];
        };
      }
    ];
  };

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
