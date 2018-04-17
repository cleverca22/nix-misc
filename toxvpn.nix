{ stdenv, fetchFromGitHub, libtoxcore, cmake, jsoncpp, lib, stdenvAdapters, libsodium, systemd, enableDebugging, libcap, zeromq }:

with lib;

let
  libtoxcoreLocked = stdenv.lib.overrideDerivation libtoxcore (oldAttrs: {
    name = "libtoxcore-20160907";
    src = fetchFromGitHub {
      owner = "cleverca22";
      repo = "toxcore";
      rev = "e4cc8c9";
      sha256 = "01i1cm5rwga7qfhjfyf6k4k410splyrgnd8icr3sldykyma3f85w";
    };
    NIX_CFLAGS_COMPILE = [ "-DMIN_LOGGER_LEVEL=LOG_TRACE" "-ggdb -Og" ];
    configureFlags = oldAttrs.configureFlags ++ [ "--enable-debug" ];

    dontStrip = true;
  });

in stdenv.mkDerivation {
  name = "toxvpn-20160909";

  src = fetchFromGitHub {
    owner  = "cleverca22";
    repo   = "toxvpn";
    rev    = "7450ba061229fd0e9e81f98b203d8e9964463f5e";
    sha256 = "0yj1c3j9acc3rxgrwpv1qhms2f2v0hhhc6xc0ks4nfd72q24glrf";
  };

  dontStrip = true;

  NIX_CFLAGS_COMPILE = [ "-ggdb -Og" ];

  buildInputs = [ cmake libtoxcoreLocked jsoncpp libsodium libcap zeromq ] ++ optional (systemd != null) systemd;

  cmakeFlags = (optional (systemd != null) [ "-DSYSTEMD=1" ]) ++
    [ ''-DBOOTSTRAP_PATH=''${out}/share/toxvpn/bootstrap.json'' ];

  postInstall = ''
    mkdir -pv ''${out}/share/toxvpn
    cp -vi ../bootstrap.json ''${out}/share/toxvpn/bootstrap.json
  '';

  meta = with stdenv.lib; {
    description = "A powerful tool that allows one to make tunneled point to point connections over Tox";
    homepage    = https://github.com/cleverca22/toxvpn;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ cleverca22 obadz ];
    platforms   = platforms.linux;
  };
}
