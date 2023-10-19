# Where the magic happens.
{
  pkgs,
  version,
  additionalLibs ? [ ],
  additionalPrograms ? [ ]
}:
let
  deps = import ./deps.nix { inherit pkgs version additionalLibs additionalPrograms; };
in
pkgs.mkShell rec {
  name = "mcdev_${version.mc}-java${version.java}";
  buildInputs = deps.inputs;
  shellHook = ''
    export LD_LIBRARY_PATH=${deps.LD_LIBRARY_PATH}:$LD_LIBRARY_PATH
    export PATH=$PATH:${deps.PATH};
  '';
  XDG_DATA_DIRS = deps.XDG_DATA_DIRS;
  XDG_RUNTIME_DIR = deps.XDG_RUNTIME_DIR;
}
