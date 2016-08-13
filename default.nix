let
  rawfunc = import <nixpkgs>;
  pkgs_arm6 = rawfunc { system = "armv6l-linux"; };
in
with rawfunc {};
{
  toxvpn = callPackage ./toxvpn.nix {};
  qemu-user-arm = pkgs.callPackage ./qemu-user.nix { user_arch = "arm"; };
  qemu-user-arm64 = pkgs.callPackage ./qemu-user.nix { user_arch = "aarch64"; };
  nix = pkgs.stdenv.lib.overrideDerivation pkgs.nix (oldAttrs: {
    patches = ./upgrade.patch;
  });
  nix_arm6 = pkgs_arm6.stdenv.lib.overrideDerivation pkgs_arm6.nix (oldAttrs: {
    patches = ./upgrade.patch;
  });
}
