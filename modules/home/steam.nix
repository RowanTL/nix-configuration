{ inputs, lib, config, ... }:

{
  imports = [ "${inputs.mastercomfig}/mastercomfig.nix" ];

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
        mouse5 = "Action Slot";
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
    };
  };
}
