# QoL wrapper script to make entering the dev shell trivial from anywhere
{
  pkgs,
  version,
  name,
  additionalLibs ? [ ],
  additionalPrograms ? [ ],
  wrappedPackage ? pkgs.bashInteractive,
  wrappedPackageBinary ? "/bin/bash"
}:
let
  stdenv = pkgs.stdenv;
  deps = import ./deps.nix { inherit pkgs version additionalLibs additionalPrograms; };
in stdenv.mkDerivation rec {
  inherit name;
  pname = name;
  version = "1.0.0";

  dontUnpack = true;

  buildInputs = deps.inputs ++ [ wrappedPackage ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    runHook preInstall
    makeWrapper ${wrappedPackage}${wrappedPackageBinary} $out/bin/${name} \
      --prefix LD_LIBRARY_PATH : ${deps.LD_LIBRARY_PATH} \
      --suffix PATH : ${deps.PATH}
    runHook postInstall
  '';
}
