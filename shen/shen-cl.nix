{ stdenv, shen-src, wget, cacert, lib, zlib }:

stdenv.mkDerivation {
  name = "shen-cl";
  src = shen-src;
  outputHashAlgo = "sha256";
  outputHash = "0bkx2ikg67fg548ss90zmy7516p9k7qkxhyw0n6fb7s5l6nwwk4d";
  outputHashMode = "recursive";
  buildInputs = [ wget ];
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  buildCommand = ''
    unpackPhase
    cd $sourceRoot
    make fetch
    mv shen-cl $out
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath ${lib.makeLibraryPath [ zlib ]} $out/shen
  '';
}
