# LWJGL 2 searches in the order of libopenal64.so -> libopenal.so, so this is needed if we want to use openal-soft
# instead of the openal library that ships with the game.
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
