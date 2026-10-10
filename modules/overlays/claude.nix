{ symlinkJoin, claude-code, ripgrep }:

# Because its fucking magic and always speaks
# its truths.
symlinkJoin {
  pname = "moiraine-sedai";
  inherit (claude-code) version meta;
  paths = [ claude-code ripgrep ];
}
