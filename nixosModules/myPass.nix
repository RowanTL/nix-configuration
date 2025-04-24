{pkgs, ...}:

{  
  environment.systemPackages = with pkgs; [
    pinentry-curses
    (pass-wayland.withExtensions (subpkgs: with subpkgs; [
      pass-tomb
      pass-otp
    ]))
  ];
  environment.etc."profile.d/pass_completions.sh".source = "${pkgs.pass-wayland.extensions.pass-otp}/share/bash-completion/completions/pass-otp";
}
