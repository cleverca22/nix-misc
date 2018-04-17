{ stdenv, shen-src, wget, cacert, lib, zlib }:

let
  fixedhash = stdenv.mkDerivation {
    name = "shen-cl";
    src = shen-src;
    outputHashAlgo = "sha256";
    outputHash = "0sgcn33mjkp2ig4mk7wg63kaqbjhh2yzxwk97yk4zk21djd21q2j";
    outputHashMode = "recursive";
    buildInputs = [ wget ];
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    buildCommand = ''
      unpackPhase
      cd $sourceRoot
      make fetch
      mv shen-cl $out
    '';
  };
in stdenv.mkDerivation {
  name = "shen-cl-patched";
  src = fixedhash;
  buildCommand = ''
    unpackPhase
    cd $sourceRoot
    mkdir $out
    mv * $out/
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${lib.makeLibraryPath [ zlib ]} $out/shen
  '';
}
