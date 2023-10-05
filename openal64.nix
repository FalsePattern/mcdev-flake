{ pkgs, ... }:
let
  stdenv = pkgs.stdenv;
  openal = pkgs.openal;
in
stdenv.mkDerivation rec {
  pname = "openal64";
  version = openal.version;
  dontUnpack = true;
  buildInputs = [ openal ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    ln -s ${openal}/lib/libopenal.so $out/lib/libopenal64.so
    runHook postInstall
  '';
}
