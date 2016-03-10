with import <nixpkgs> {};
{
  toxvpn = callPackage ./toxvpn.nix {};
  qemu-user-arm = pkgs.callPackage ./qemu-user.nix { user_arch = "arm"; };
  qemu-user-arm64 = pkgs.callPackage ./qemu-user.nix { user_arch = "aarch64"; };
  nix = pkgs.stdenv.lib.overrideDerivation pkgs.nix (oldAttrs: {
    patches = ./upgrade.patch;
  });
}
