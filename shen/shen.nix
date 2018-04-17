{ stdenv, shen-src, shen-cl }:

stdenv.mkDerivation {
  name = "shen";
  src = shen-src;
  prePatch = ''
    ln -sv ${shen-cl} shen-cl
    ls -ltrh
  '';
}
