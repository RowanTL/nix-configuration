{ pkgs, ... }:

# Thanks to this tutorial
# https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager
{
  imports = [
    ./ide/helix.nix
    ./git.nix
    ./ssh.nix
    ./shell.nix
  ];

  # Truly need this here to use flakes :(
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

    # AI related
    claude-code
  ];

  # enable and use librewolf as default web browser
  programs.librewolf = {
    enable = true;
    # Can add extra config here if wanted
    # https://nixos.wiki/wiki/Librewolf
    settings = {
      "browser.toolbars.bookmarks.visibility" = "never";
    };
  };
  # programs.floorp = {
    # enable = true;
    # globalExtensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #   {
    #     package = ublock-origin;
    #     settings = {
    #       private_browsing = true;
    #     };
    #   }
    # ];
  # };
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/discord" = "legcord.desktop";
    "x-scheme-handler/sgnl" = "signal.desktop";
    "x-scheme-handler/signalcaptcha" = "signal.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "text/html" = "librewolf.desktop";
    # "x-scheme-handler/http" = "floorp.desktop";
    # "x-scheme-handler/https" = "floorp.desktop";
    # "text/html" = "floorp.desktop";
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
