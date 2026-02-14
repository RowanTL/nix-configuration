{ lib, config, ... }:

{
  options = {
    ssh.enable
      = lib.mkEnableOption "enable custom ssh config";  
  };
  
  config = lib.mkIf config.ssh.enable {
    programs.ssh = {
      enable = true;
      extraConfig = "
        Host github.com
          Hostname github.com
          IdentityFile ~/.ssh/github

        Host 99.50.111.149
          Hostname 99.50.111.149
          IdentityFile ~/.ssh/roebox

        Host 192.168.1.139
          Hostname 192.168.1.139
          IdentityFile ~/.ssh/roebox
      ";
    };
  };
}
