# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ../../nixosModules/git.nix
      ../../nixosModules/tmux.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command"  "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "roebox"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  users.users.roe = {
    isNormalUser = true;
    description = "Rowan";
    extraGroups = [ "wheel" ];
    # packages = with pkgs; [
    
    # ];
  };

  # For nginx to work with acme
  # https://bkiran.com/blog/using-nginx-in-nixos
  users.users.nginx.extraGroups = [ "acme" ];

  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/var/lib/gitea-server";
    createHome = true;
    # shell = "${pkgs.git}/bin/git-shell";
    shell = "/var/lib/gitea-server/ssh-shell";
  };

  users.groups.git = {};

  programs.firefox.enable = true;
  # Environment specification
  environment = {
    systemPackages = with pkgs; [
      git
      stow
      wget
      inputs.nixpkgsUnstable.legacyPackages.${pkgs.system}.helix # helix from the unstable repo thx to a flake
      nil
      htop
    ];
    variables = {
      SUDO_EDITOR = "hx";
      EDITOR = "hx";
    };
  };
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = true;
      PermitRootLogin = "no";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  networking.firewall.allowedUDPPorts = [ 22 80 443 ];
  networking.firewall.extraCommands = "iptables -A INPUT -s 20.171.207.204 -j DROP";
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Pulled directly from the wiki
  # https://nixos.wiki/wiki/Nginx
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    appendHttpConfig = ''
      # Add HSTS header with preloading to HTTPS requests.
      # Adding this header to HTTP requests is discouraged
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;

      # Enable CSP for your services.
      #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

      # Minimize information leaked to other domains
      add_header 'Referrer-Policy' 'origin-when-cross-origin';

      # Disable embedding as a frame
      add_header X-Frame-Options DENY;

      # Prevent injection of code in other mime types (XSS Attacks)
      add_header X-Content-Type-Options nosniff;

      # This might create errors
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";

      # Someone is scraping my all of my commit history at one commit per second?????
      # Gonna stop this from happening.
      # limit_req_zone $binary_remote_addr zone=one:10m rate=55r/m;
    '';

    # The definitions of the individual sites go here.
    virtualHosts."evotrade.org" = {
      serverName = "evotrade.org";
      useACMEHost = "evotrade.org";
      acmeRoot = "/var/lib/acme/challenges-evotrade";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3009";
        # extraConfig = ''
          # limit_req zone=one;
        # '';
      };
    };

    virtualHosts."git.evotrade.org" = {
      serverName = "git.evotrade.org";
      useACMEHost = "evotrade.org";
      acmeRoot = "/var/lib/acme/challenges-evotrade";
      addSSL = true;
      forceSSL = false;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
        # extraConfig = ''
          # limit_req zone=one;
        # '';
      };
    };

    virtualHosts.default = {
      serverName = "_";
      default = true;
      rejectSSL = true;
      locations."/".return = "444";
    };
  };

  # SSL cert renewal
  security.acme = {
    acceptTerms = true;
    defaults.email = "rowan.a.tl@protonmail.com";
    certs."evotrade.org" = {
      webroot = "/var/lib/acme/challenges-evotrade";
      email = "rowan.a.tl@protonmail.com";
      group = "nginx";
      extraDomainNames = [
        "git.evotrade.org"
      ];
    };
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
