{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "steam-input-rules";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/ValveSoftware/steam-devices/master/60-steam-input.rules";
    sha256 = "0k92pjn2yx09wqya4mgy3xrqg2g77zpsgzgayfg77r6ljl88b81j";
  };
  installPhase = ''
    mkdir -p $out/etc/udev/rules.d
    cp $src $out/etc/udev/rules.d/60-steam-input.rules
  '';
}
