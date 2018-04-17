with import <nixpkgs> {};
let
  packages = self: {
    shen-src = self.callPackage ./shen-src.nix {};
    shen-cl = self.callPackage ./shen-cl.nix {};
    shen = self.callPackage ./shen.nix {};
  };
in lib.makeScope newScope packages
