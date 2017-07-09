{ stdenv, fetchurl, python, pkgconfig, zlib, glib, user_arch, flex, bison, makeStaticLibraries, glibc }:

let
  env2 = makeStaticLibraries stdenv;
  myglib = glib.override { stdenv = env2; };
in
stdenv.mkDerivation rec {
  name = "qemu-user-${user_arch}-${version}";
  version = "2.7.0";
  buildInputs = [ python pkgconfig zlib.static myglib flex bison glibc.static ];
  src = fetchurl {
    url = "http://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    sha256 = "0lqyz01z90nvxpc3nx4djbci7hx62cwvs5zwd6phssds0sap6vij";
  };
  configureFlags = [
    "--enable-linux-user" "--target-list=${user_arch}-linux-user"
    "--disable-bsd-user" "--disable-system" "--disable-vnc" "--without-pixman"
    #"--disable-vnc-tls"
    "--disable-curses" "--disable-sdl" "--disable-vde"
    "--disable-bluez" "--disable-kvm"
    "--static"
    "--disable-tools"
  ];
  NIX_LDFLAGS = [ "-lglib-2.0" "-lssp" ];
  postInstall = ''
    cat <<EOF > $out/bin/register
    #!/bin/sh
    modprobe binfmt_misc
    mount -t binfmt_misc binfmt_misc  /proc/sys/fs/binfmt_misc
    ${
      if user_arch == "arm" then ''echo   ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff:$out/bin/qemu-arm:' > /proc/sys/fs/binfmt_misc/register''
      else if user_arch == "aarch64" then ''echo   ':aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff:$out/bin/qemu-aarch64:' > /proc/sys/fs/binfmt_misc/register''
      else "echo unknown arch"
    }
    EOF
    chmod +x $out/bin/register
  '';
}
