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
        nixos.command = lib.getExe pkgs.mcp-nixos;

        rea = {
          command = lib.getExe' pkgs.nodejs "npx";
          args = [ "-y" "rea-agents@6.3.0" "mcp" ];
        };
      };
    };
  };
}
