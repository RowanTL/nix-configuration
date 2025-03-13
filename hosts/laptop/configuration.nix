# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
  unstablepkgs = inputs.nixpkgsUnstable.legacyPackages.${pkgs.system};
in
{
  imports =
    [
      ./hardware-configuration.nix
      ../../nixosModules/git.nix
      ../../nixosModules/tmux.nix
      ../../nixosModules/myVSCodium.nix
      ../../nixosModules/myPass.nix
      inputs.home-manager.nixosModules.default
    ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = inputs.nixpkgsUnstable.legacyPackages.${pkgs.system}.linuxKernel.packages.linux_zen;

  networking.hostName = "rowan-laptop"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    wlr.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  users.users.rowan = {
    isNormalUser = true;
    description = "Rowan Torbitzky-Lane";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };
  programs.light.enable = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs; };
    users = {
      "rowan" = import ./home.nix;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      git
      stow
      wget
      unstablepkgs.helix # helix from the unstable repo thx to a flake
      brave
      librewolf
      nil
      protonup
      htop
      youtube-music
      ranger
      glow
      signal-desktop
      kitty
      wl-clipboard
      unzip
    ];
    variables = {
      SUDO_EDITOR = "hx";
      EDITOR = "hx";
    };
    sessionVariables = {
      # WLR_NO_HARDWARE_CURSORS = "1"; # If cursor is invisible
      NIXOS_OZONE_WL = "1";
    };
    localBinInPath = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    opengl.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
