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

        Host 99.50.111.149
          Hostname 99.50.111.149
          IdentityFile ~/.ssh/roebox

        Host 192.168.1.139
          Hostname 192.168.1.139
          IdentityFile ~/.ssh/roebox
      ";
      matchBlocks."*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}
