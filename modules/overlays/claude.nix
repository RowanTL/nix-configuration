{ symlinkJoin, claude-code, ripgrep }:

symlinkJoin {
  pname = "moiraine-sedai";
  inherit (claude-code) version meta;
  paths = [ claude-code ripgrep ];
}
