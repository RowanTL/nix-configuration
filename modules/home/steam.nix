{ inputs, lib, config, pkgs, ... }:

let
  heavyAnimations = pkgs.fetchzip {
    url = "https://gamebanana.com/dl/1227659";
    extension = "zip";
    hash = "sha256-SKRbhCHhhpwxDfLdN9E6ViPP2nfrwdLuCnOnUPJxtRI=";
    stripRoot = false;
  };
in
{
  imports = [ inputs.tf2-nix.homeManagerModules.default ];

  options = {
    home-steam.enable
      = lib.mkEnableOption "enable home steam configuration";
  };

  config = lib.mkIf config.home-steam.enable {
    programs.mastercomfig = {
      enable = true;
      preset = "medium";
      addons = [ "flat-mouse" "no-pyroland" "no-tutorial" "null-canceling-movement" ];

      # I'm on colemak so need different keybindings
      binds = {
        w = "Move Forward";
        a = "Move Left";
        r = "Move Back";
        s = "Move Right";
        p = "Reload weapon";
        d = "Taunts";
        f = "Call MEDIC!";
        t = "Inspect";
        g = "Chat message";
        j = "Team message";
        l = "Party message";
        k = "Explode (self)";
        m = "Open loadout";
        q = "Last weapon used";
        "0" = "Weapon slot 10";
        "1" = "Weapon slot 1";
        "2" = "Weapon slot 2";
        "3" = "Weapon slot 3";
        "4" = "Weapon slot 4";
        "5" = "Weapon slot 5";
        "6" = "Weapon slot 6";
        u = "Open Map information";
        v = "Push to Talk";
        space = "Jump";
        tab = "Show scoreboard";
        escape = "cancelselect";
        b = "Spy: Last Disguise";
        z = "Voice Menu 1";
        x = "Voice Menu 2";
        c = "Voice Menu 3";
        "-" = "cl_decline_first_notification";
        "=" = "cl_trigger_first_notification";
        e = "Kill (self)";
        i = "Drop";
        shift = "Duck";
        mouse1 = "Primary attack";
        mouse2 = "Secondary attack";
        mouse3 = "Special attack";
        mouse4 = "Action Slot";
        mouse5 = "Special attack";
        mwheelup = "Previous weapon";
        mwheeldown = "Next weapon";
        uparrow = "Loadout A";
        leftarrow = "Loadout B";
        downarrow = "Loadout C";
        rightarrow = "Loadout D";
        "[" = "say this is also a bind";
        "]" = "say this is a bind";
        "`" = "toggleconsole";
        "," = "changeclass";
        "." = "changeteam";
      };

      crosshairs = {
        weapons = {
          tf_weapon_rocketlauncher_directhit = "dot";
        };
        scale.soldier = 20;
      };
    };

    programs.budhud = {
      enable = true;
    };

    # Bowless huntsman: https://gamebanana.com/mods/654496
    programs.tf2-preload = {
      enable = true;
      vpks = {
        market-gardener.source = "${pkgs.fetchzip {
          url = "https://gamebanana.com/dl/1240416";
          extension = "zip";
          hash = "sha256-2V5eCOLt/UXJQx808pxD5vvCkVVm69tQezKsf4YT10k=";
          stripRoot = false;
        }}/elfi_minecraft_diamond_shovel_market_gardener V1.vpk";

        # First person animations, using the 70 FOV versions to match my
        # viewmodel_fov
        sniper-animations.source = "${pkgs.fetchzip {
          url = "https://gamebanana.com/dl/428381";
          extension = "zip";
          hash = "sha256-FjAJG8f7qV3eS0QOFREX2LTWgVLVwdwashcLNxiEQVA=";
          stripRoot = false;
        }}/Sniper FP Anim Overhaul.vpk";
        engineer-animations.source = "${pkgs.fetchzip {
          url = "https://gamebanana.com/dl/873373";
          extension = "zip";
          hash = "sha256-zSGsozh5Gkc0lHuxD4oRDcT68Ybk0xI3vHr8saVqLM4=";
          stripRoot = false;
        }}/Engy.vpk";
        medic-animations.source = "${pkgs.fetchzip {
          url = "https://gamebanana.com/dl/520054";
          extension = "zip";
          hash = "sha256-xA0zNnhVM1miMP6fANn3p1saRhuCl31qw9UyLOh21Uw=";
          stripRoot = false;
        }}/70FovFix.vpk";
        # Earlier names in custom/ take priority, so the alts have to sort
        # before the main VPK, which also has the classic versions
        heavy-animations-alt-fists.source =
          "${heavyAnimations}/70+ FOV/Heavy FP Animation Overhaul V3.1 - Alt Fist Animations.vpk";
        heavy-animations-alt-minigun.source =
          "${heavyAnimations}/70+ FOV/Heavy FP Animation Overhaul V3.1 - Alt Minigun Animations.vpk";
        heavy-animations-main.source =
          "${heavyAnimations}/70+ FOV/Heavy FP Animation Overhaul V3.11.vpk";
        scout-animations.source = "${pkgs.fetchzip {
          url = "https://gamebanana.com/dl/387155";
          extension = "zip";
          hash = "sha256-KZYMhDKkoAyStcKIRaLfegOS8ISFNIow2NCHEgUmhbI=";
          stripRoot = false;
        }}/ScoutOverhaulV3/Scout FP Overhaul - 70+ FOV.vpk";
        spy-animations.source = "${pkgs.fetchzip {
          url = "https://gamebanana.com/dl/210154";
          extension = "rar";
          nativeBuildInputs = [ pkgs.unar ];
          hash = "sha256-NISWFsi4cxxrl+F/Q65PmQWBsmSVnmokBiYAvidlceo=";
          stripRoot = false;
        }}/download/00A - Spy Overhaul - Alt Revolver Draw.vpk";
        soldier-animations.source = "${pkgs.fetchzip {
          url = "https://gamebanana.com/dl/206752";
          extension = "rar";
          nativeBuildInputs = [ pkgs.unar ];
          hash = "sha256-0QEkYZIF3At5vA+MDtnfi6AfYYJqVgOjZsZaSO4tUTU=";
          stripRoot = false;
        }}/download/Soldier FP Anims Remade V.1.5.0 - 70 FOV.vpk";
        demoman-animations.source = "${pkgs.fetchzip {
          url = "https://gamebanana.com/dl/387943";
          extension = "zip";
          hash = "sha256-TW3MzM/v6Vog2NG+9de9xvrogpLcVQzS7x7PeInfhXY=";
          stripRoot = false;
        }}/Demo FP Anims - Far.vpk";
      };

      particleMods.toon-explosions.source = "${pkgs.fetchzip {
        url = "https://gamebanana.com/dl/39707";
        extension = "rar";
        nativeBuildInputs = [ pkgs.unar ];
        hash = "sha256-yrnpQ6KzMNheem2bkWlSgLA7vaomULRGt4BTwBS6CRQ=";
        stripRoot = false;
      }}/download/toon_explosions_v1.1.vpk";
      particleMods.reduced-flames.source = "${pkgs.fetchzip {
        url = "https://gamebanana.com/dl/1027935";
        extension = "rar";
        nativeBuildInputs = [ pkgs.unar ];
        hash = "sha256-5nyZEQPFdn8RIuUxbQ1eeQoLho+BJyTijRvXVD3puYM=";
        stripRoot = false;
      }}/nofire";
      # Rocket, stickybomb and grenade explosions
      particles.explosion = "toon-explosions";
      particles.flamethrower = "reduced-flames";
    };
  };
}
