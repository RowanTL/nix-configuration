{pkgs, ...}:

{  
  environment.systemPackages = with pkgs; [
    pinentry-curses
    (pass-wayland.withExtensions (subpkgs: with subpkgs; [
      pass-tomb
      pass-otp
    ]))
  ];
}
