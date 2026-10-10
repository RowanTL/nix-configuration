{inputs, lib, config, ... }:

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
        "=" = "View/Accept alert";
      };
    };
  };
}
