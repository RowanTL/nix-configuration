{ inputs, lib, config, pkgs, ... }:

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

    programs.tf2-preload = {
      enable = true;
      vpks = {
        market-gardener.source = "${pkgs.fetchzip {
          url = "https://gamebanana.com/dl/1240416";
          extension = "zip";
          hash = "sha256-2V5eCOLt/UXJQx808pxD5vvCkVVm69tQezKsf4YT10k=";
          stripRoot = false;
        }}/elfi_minecraft_diamond_shovel_market_gardener V1.vpk";
      };
    };
  };
}
