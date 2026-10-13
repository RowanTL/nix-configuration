{ pkgs, lib, config }:

{
  options = {
    virtualization.enable
      = lib.mkEnableOption "enable custom virtualization config";
  };

  config = lib.mkIf config.virtualization.enable {
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = ["rowan"];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    users.users.rowan.extraGroups = [ "libvirtd" ];
  };
}
