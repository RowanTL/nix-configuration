{ lib, config, pkgs, ... }:

{
  options = {
    home-prismlauncher.enable
      = lib.mkEnableOption "enable custom git";  
  };
  
  config = lib.mkIf config.home-prismlauncher.enable {
    home.packages = with pkgs; [
      (prismlauncher.override {
        additionalPrograms = [ ffmpeg ];

        # Change Java runtimes available to Prism Launcher
        jdks = [
          graalvmPackages.graalvm-ce
          zulu8
          zulu17
          zulu
        ];
      })
    ];
  };
}
