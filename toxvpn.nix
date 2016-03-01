{ stdenv, fetchFromGitHub, libtoxcore, cmake, jsoncpp, lib, stdenvAdapters, libsodium, systemd, enableDebugging, libcap }:

with lib;

let
  libtoxcoreLocked = stdenv.lib.overrideDerivation libtoxcore (oldAttrs: {
    name = "libtoxcore-20151110";
    src = fetchFromGitHub {
      owner = "irungentoo";
      repo = "toxcore";
      rev = "e1089c1779fb1c58f17937108a6ba8c3d39573ae";
      sha256 = "13dvxqx5xkhmxiyc9lx67fzacibzr32fl3m92qn7g1rb723giha4";
    };
  });
  stdenv2 = stdenvAdapters.keepDebugInfo stdenv;
in

stdenv.mkDerivation {
  name = "toxvpn-20151111";
  buildInputs = [ cmake libtoxcoreLocked jsoncpp libsodium systemd libcap ];
  src = fetchFromGitHub {
    owner = "cleverca22";
    repo = "toxvpn";
    rev = "1d06bb7da277d46abb8595cf152210c4ccf0ba7d";
    sha256 = "1himrbdgsbkfha1d87ysj2hwyz4a6z9yxqbai286imkya84q7r15";
  };
  meta = {
    description = "a tox based vpn program";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
