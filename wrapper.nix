{ pkgs, devShell, name, ... }:
let
  stdenv = pkgs.stdenv;
in
stdenv.mkDerivation rec {
  inherit name;
  pname = name;
  version = "1.0.0";

  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall
    makeWrapper ${pkgs.nix}/bin/nix $out/bin/${name} \
      --add-flags "develop ${./.}#\\\"${devShell}\\\""
    runHook postInstall
  '';
}
