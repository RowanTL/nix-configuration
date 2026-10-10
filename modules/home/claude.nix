{ lib, config, pkgs, ... }:

let
  reaVersion = "6.3.0";
  reaSrc = pkgs.fetchzip {
    url = "https://registry.npmjs.org/rea-agents/-/rea-agents-${reaVersion}.tgz";
    hash = "sha256-CasX80vUEj7eVIi77G39G/sMdB3biihDWI179x03Jxg=";
    stripRoot = false;
  };
  # rea-agents has a `#!/usr/bin/env node` shebang, and node isn't on the PATH
  # claude launches MCP servers with
  reaMcp = pkgs.writeShellApplication {
    name = "rea-mcp";
    runtimeInputs = [ pkgs.nodejs ];
    text = ''exec npx -y rea-agents@${reaVersion} mcp'';
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

        rea.command = lib.getExe reaMcp;
      };

      skills.reverse-engineer-anything = "${reaSrc}/package/skills/reverse-engineer-anything";
    };
  };
}
