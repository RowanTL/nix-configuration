# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# May need to place pkgs or config as arguments later
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/os # basic configuration nice for all systems
    ../../modules/os/bluetooth.nix
    ../../modules/os/sddm.nix
    ../../modules/os/steam.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # secondary drives, kept here rather than hardware-configuration.nix since
  # that file gets overwritten by nixos-generate-config
  fileSystems."/mnt/storage" =
    { device = "/dev/disk/by-uuid/7f0a653d-9588-480e-821e-3f6299624521";
      fsType = "ext4";
      options = [ "nofail" ];
    };

  fileSystems."/mnt/ssd" =
    { device = "/dev/disk/by-uuid/7c0bfaf9-d976-48e4-9aae-f2c3c479c225";
      fsType = "ext4";
      options = [ "nofail" ];
    };

  # custom kernel for gaming
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "rowan-desktop";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # custom rowan stuff
  bluetooth.enable = true;
  sddm.enable = true;
  steam.enable = true;

  # kde so I can play TF2
  services.desktopManager.plasma6.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rowan = {
    isNormalUser = true;
    description = "rowan";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
    ];
    # packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # temporary distrobox to program on ti-84
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    distrobox
  ];

  # intel integrated settings
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # https://wiki.nixos.org/wiki/Intel_Graphics
    # extraPackages = with pkgs; [
    # intel-media-sdk # marked as insecure so don't use
    # ];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #   enableSSHSupport = true;
  };

  # Syncthing
  # services.syncthing = {
  #   enable = true;
  #   openDefaultPorts = true;
  #   user = "rowan";
  #   dataDir = "/home/rowan/syncthing";
  #   configDir = "/home/rowan/.config/syncthing";
  #   settings = {
  #     devices = {
  #       "rowan-laptop" = {id = "DS5Z3LS-YRTVBEB-CFZBOOA-TS5VUEZ-EIL4P2X-3LVRB3S-E5KWCHK-CXQPEA5"; };
  #     };
  #     folders = {
  #       "bvjky-kxgig" = {
  #         path = "/home/rowan/syncthing/Sync";
  #         devices = [ "rowan-laptop" ];
  #       };
  #     };
  #   };
  # };

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
