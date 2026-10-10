final: prev: {
  rand-al'thor = final.callPackage ./brave.nix { };
  moiraine-sedai = final.callPackage ./claude.nix { };
}
