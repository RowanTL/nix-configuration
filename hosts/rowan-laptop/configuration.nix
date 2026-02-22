# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/os/sway.nix
      ../../modules/os # basic configuration nice for all systems
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "rowan-laptop-test"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # sway configuration stuff
  sway.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rowan = {
    isNormalUser = true;
    description = "rowan";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # intel integrated settings
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    # https://wiki.nixos.org/wiki/Intel_Graphics
    extraPackages = with pkgs; [
      intel-media-sdk
    ];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
  #   enableSSHSupport = true;
  };

  # Display Manager
  services.displayManager.ly.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "rowan";
    dataDir = "/home/rowan/syncthing";
    configDir = "/home/rowan/.config/syncthing";
    settings = {
      devices = {
        "desktop" = {id = "OJYCLD3-L7O6TLX-E6GGVQ2-XMPNIWR-EJMW56I-2OMCG7H-AJDIXKE-DISX4AJ"; };
      };
      folders = {
        "bvjky-kxgig" = {
          path = "/home/rowan/syncthing/Sync";
          devices = [ "desktop" ];
        };
      };
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
