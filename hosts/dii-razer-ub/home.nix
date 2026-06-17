{ config, pkgs, ... }:

{
  nix.package = pkgs.nix;

  targets.genericLinux = {
    enable = true;
    gpu.nvidia = {
      enable = true;
      version = "595.71.05";
      sha256 = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
    };
  };
  # gpu offloading
  # targets.genericLinux.nixGL.prime.installScript = "nvidia";

  imports = [
    ./../../modules/home
    ./../../modules/home/helix.nix
    ./../../modules/home/git.nix
    ./../../modules/home/ssh.nix
    ./../../modules/home/sway.nix
    ./../../modules/home/zed.nix
  ];
  home.username = "rtorblane";
  home.homeDirectory = "/home/rtorblane";

  home-sway = {
    enable = true;
    enableIdle = false;
  };
  home-zed.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.blender
    # pkgs.ollama-cuda
  ];

  systemd.user.services.ollama = {
    Unit.Description = "Ollama GPU Service";
    Install.WantedBy = [ "default.target" ];
    Service = {
      ExecStart = "${pkgs.ollama-cuda}/bin/ollama serve";
      Environment = "LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/nvidia";

      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  # home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  # };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/rtorblane/etc/profile.d/hm-session-vars.sh
  #
  # home.sessionVariables = {
    # EDITOR = "emacs";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
