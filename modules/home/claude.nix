{ lib, config, pkgs, ... }:

{
  options = {
    home-claude.enable
      = lib.mkEnableOption "enable custom claude code";
  };

  config = lib.mkIf config.home-claude.enable {
    programs.claude-code = {
      enable = true;
      # moiraine-sedai is claude-code plus ripgrep, from modules/overlays
      package = pkgs.moiraine-sedai;

      mcpServers = {
        # https://github.com/utensils/mcp-nixos
        nixos.command = lib.getExe pkgs.mcp-nixos;

        # https://github.com/morluto/rea
        # Not packaged for nix, so it runs from npm. Pinned to an exact version
        # as the docs recommend; needs node >= 24.11 (or 22.19).
        rea = {
          command = lib.getExe' pkgs.nodejs "npx";
          args = [ "-y" "rea-agents@6.3.0" "mcp" ];
        };
      };
    };
  };
}
