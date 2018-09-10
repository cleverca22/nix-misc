{ pkgs ? null }:
let
  rawfunc = import <nixpkgs>;
  pkgs_host = if pkgs != null then pkgs else rawfunc {};
  pkgs_arm6 = rawfunc { system = "armv6l-linux"; };
in
with pkgs_host;
{
  toxvpn = callPackage ./toxvpn.nix {};
  #nix = pkgs_host.stdenv.lib.overrideDerivation pkgs_host.nix (oldAttrs: {
  #  patches = ./upgrade-unstable.patch;
  #});
  nix_arm6 = pkgs_arm6.stdenv.lib.overrideDerivation pkgs_arm6.nix (oldAttrs: {
    patches = ./upgrade.patch;
  });
  reallySlow = runCommand "reallySlow" {} ''
    sleep ${toString (3600 * 13)}
    echo foo
    touch $out
  '';
  sortaSlow = runCommand "sortaSlow" {
    meta = {
      timeout = 60;
      maxSilent = 90;
      description = "testing";
    };
  } ''
    sleep 600
    echo test2
    touch $out
  '';
}
