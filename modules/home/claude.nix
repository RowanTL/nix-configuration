{ lib, config, pkgs, ... }:

let
  reaVersion = "6.3.0";
  reaSrc = pkgs.fetchzip {
    url = "https://registry.npmjs.org/rea-agents/-/rea-agents-${reaVersion}.tgz";
    hash = "sha256-CasX80vUEj7eVIi77G39G/sMdB3biihDWI179x03Jxg=";
    stripRoot = false;
  };
in
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
          args = [ "-y" "rea-agents@${reaVersion}" "mcp" ];
        };
      };

      skills.reverse-engineer-anything = "${reaSrc}/package/skills/reverse-engineer-anything";
    };
  };
}
