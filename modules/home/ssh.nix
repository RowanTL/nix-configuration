{ lib, config, ... }:

{
  options = {
    home-ssh.enable
      = lib.mkEnableOption "enable custom ssh config";  
  };
  
  config = lib.mkIf config.home-ssh.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      extraConfig = "
        Host github.com
          Hostname github.com
          IdentityFile ~/.ssh/github

        Host gitlab.com
          Hostname gitlab.com
          IdentityFile ~/.ssh/gitlab

        Host 99.50.111.149
          Hostname 99.50.111.149
          IdentityFile ~/.ssh/roebox

        Host 192.168.1.139
          Hostname 192.168.1.139
          IdentityFile ~/.ssh/roebox
      ";
      settings."*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };
}
