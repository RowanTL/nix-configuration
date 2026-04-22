{ lib, config, ... }:

{
  options = {
    steam.enable
      = lib.mkEnableOption "enable custom steam config";
  };

  config = lib.mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    }; 
    programs.gamemode.enable = true;

    # Some networking optimizations that may be worth placing
    # into its own file.

    # Pulled from https://wiki.archlinux.org/title/Sysctl#
    boot.kernel.sysctl = {
      "net.core.netdev_max_backlog" = 16384;
      "net.core.rmem_default" = 1048576;
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_default" = 1048576;
      "net.core.wmem_max" = 16777216;
      "net.core.optmem_max" = 65536;
      "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
      "net.ipv4.udp_rmem_min" = 8192;
      "net.ipv4.udp_wmem_min" = 8192;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_sack" = 1;
      "vm.vfs_cache_pressure" = 50;
    };
  };
}
