{ lib, config, pkgs, ... }:

let
  reaVersion = "6.5.0";
  reaSrc = pkgs.fetchzip {
    url = "https://registry.npmjs.org/rea-agents/-/rea-agents-${reaVersion}.tgz";
    hash = "sha256-OsXkOnJSnwlPusLTQvXhfq7/TH0t/iOctzJstQ/rAjQ=";
    stripRoot = false;
  };
  mattpocockSkills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "v1.3.1";
    hash = "sha256-/mAmj7QFdyOWhLmy3Rt2/Hfsh5qwirTRax7hmQffFdo=";
  };
  mattpocockCategories = [ "engineering" "productivity" ];
  mattpocockSkillSet = lib.foldl' (acc: category:
    acc // lib.mapAttrs
      (name: _: "${mattpocockSkills}/skills/${category}/${name}")
      (lib.filterAttrs (_: type: type == "directory")
        (builtins.readDir "${mattpocockSkills}/skills/${category}"))
  ) { } mattpocockCategories;
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

      skills = mattpocockSkillSet // {
        reverse-engineer-anything = "${reaSrc}/package/skills/reverse-engineer-anything";
      };
    };
  };
}
