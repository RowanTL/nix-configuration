{ lib, config, pkgs, ... }:

{
  options = {
    home-vscode.enable
      = lib.mkEnableOption "enable custom vscode";
  };

  config = lib.mkIf config.home-vscode.enable {
    programs.vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        visualstudiotoolsforunity.vstuc  # Unity development package
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "lean4";
          publisher = "leanprover";
          version = "0.0.238";
          sha256 = "IhEmBDy+j+Ha5WHx+L9zLfd3e7jGb3cZSLAUZv3+RsE=";
        }
        {
          name = "even-better-toml";  # lean4 depends on this
          publisher = "tamasfe";
          version = "0.21.2";
          sha256 = "IbjWavQoXu4x4hpEkvkhqzbf/NhZpn8RFdKTAnRlCAg=";
        }
      ];
    };
  };
}
