# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let unstablepkgs = inputs.nixpkgsUnstable.legacyPackages.${pkgs.system}; in
{
  imports =
    [ # Include the results of the hardware scan.
      ../../nixosModules/git.nix
      ../../nixosModules/tmux.nix
      ../../nixosModules/myPass.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command"  "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu "];
  boot.kernelPackages = inputs.nixpkgsUnstable.legacyPackages.${pkgs.system}.linuxKernel.packages.linux_zen;

  networking.hostName = "rowan-desktop"; # Define your hostname.

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

  # Xserver management
  services.xserver = {
    enable = true;
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "rowan";
      sddm.enable = true;
    };
    desktopManager.plasma6.enable = true;
    xkb = {
      layout = "us";
      variant = ""; # could make this colemak but not because of my keyboard.
    };
    videoDrivers = [ "amdgpu" ];
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

  # Bluetooth :)
  # services.blueman.enable = true;

  users.users.rowan = {
    isNormalUser = true;
    description = "Rowan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      webcord
      (prismlauncher.override {
        additionalPrograms = [ ffmpeg ];
        jdks = [
          graalvm-ce
          zulu8
          zulu17
          zulu
        ];
        gamemodeSupport = true;
      })
    ];
  };

  # Environment specification
  environment = {
    systemPackages = with pkgs; [
      git
      stow
      wget
      unstablepkgs.helix # helix from the unstable repo thx to a flake
      brave
      librewolf
      gamescope
      nil
      protonup
      htop
      youtube-music
      ranger
      glow
      signal-desktop
      steam
      protonvpn-gui
    ];
    variables = {
      SUDO_EDITOR = "hx";
      EDITOR = "hx";
      NIXPKGS_ALLOW_UNFREE = 1;
    };
    sessionVariables = {
     STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/rowan/.steam/root/compatibilitytools.d";
    };
  };
  
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
    partition-manager.enable = true;
  };

  # various hardware configurations.
  hardware = {
    graphics = {
      enable = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
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
