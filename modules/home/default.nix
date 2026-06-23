{ pkgs, ... }:

# Thanks to this tutorial
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
{
  imports = [
    ./helix.nix
    ./git.nix
    ./ssh.nix
    ./shell.nix
  ];

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

    fastfetch
    signal-desktop
    protonmail-desktop
    proton-pass
    proton-vpn

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
    bluetuith
    vlc

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    unixtools.net-tools

    # global language servers
    nil
  ];

  # enable and use librewolf as default web browser
  # Librewolf is marked as insecure. Replace with something else for
  # the time being.
  # programs.librewolf = {
  #   enable = true;
  #   # Can add extra config here if wanted
  #   # https://nixos.wiki/wiki/Librewolf
  #   settings = {
  #     "browser.toolbars.bookmarks.visibility" = "never";
  #   };
  # };
  programs.floorp = {
    enable = true;
    globalExtensions = with pkgs.nur.repos.rycee.firefox-addons; [
      {
        package = ublock-origin;
        settings = {
          private_browsing = true;
        };
      }
    ];
  };
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/discord" = "legcord.desktop";
    "x-scheme-handler/sgnl" = "signal.desktop";
    "x-scheme-handler/signalcaptcha" = "signal.desktop";
    # "x-scheme-handler/http" = "librewolf.desktop";
    # "x-scheme-handler/https" = "librewolf.desktop";
    # "text/html" = "librewolf.desktop";
  };

  # Enable my custom configs
  home-helix.enable = true;
  home-git.enable = true;
  home-ssh.enable = true;
  home-shell.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
    SUDO_EDITOR = "hx";
  };
}
