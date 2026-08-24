# A file for intel specific configuration to increase battery life
# Configuration pulled from https://nixos.wiki/wiki/Laptop

{ lib, config, pkgs, ... }:

{
  options = {
    intel.enable
      = lib.mkEnableOption "enable laptop intel configuration";
  };

  config = lib.mkIf config.intel.enable {
    services.thermald.enable = true;
    # Enable as thermald is misclassifying my laptop lol
    services.thermald.ignoreCpuidCheck = true;
    ## This is AI comment I'm leaving in for now. Remove this later.
    # thermald 2.5.12 has an upstream regression that misdetects genuine
    # mobile CPUs (incl. this one) as non-mobile and exits immediately;
    # --ignore-cpuid-check doesn't cover this check. Pin back to 2.5.11
    # until upstream fixes it: https://github.com/intel/thermal_daemon/issues/550
    services.thermald.package = pkgs.thermald.overrideAttrs (old: rec {
      version = "2.5.11";
      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "thermal_daemon";
        rev = "v${version}";
        hash = "sha256-IHBfNqiMd2q5vj+xpo31LFy19zwv0GkB0GoHq8Ni7aA=";
      };
    });
  };
}
