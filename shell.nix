{ pkgs, lib ? pkgs.lib, version }:
let
  importPkg = path: pkgs.callPackage (import path) { inherit pkgs; };

  openal64 = importPkg ./openal64.nix;

  x11Deps = with pkgs.xorg; [
    libX11
    libXext
    libXcursor
    libXrandr
    libXxf86vm
    libXrender
    libXi
    libXtst
  ];

  lwjglDeps = with pkgs; [
    # lwjgl
    libpulseaudio
    libGL
    openal
    openal64
    glfw
    stdenv.cc.cc.lib
  ];

  oshiDeps = with pkgs; [
    udev
  ];

  runtimeLibs = x11Deps ++ lwjglDeps ++ oshiDeps ++ [ version.java_pkg ];
  runtimePrograms = with pkgs; [
    xorg.xrandr
    mesa-demos # need glxinfo
  ];
in
pkgs.mkShell rec {
  name = "mcdev_${version.mc}-java${version.java}";
  buildInputs = runtimeLibs ++ runtimePrograms;
  shellHook = ''
    export LD_LIBRARY_PATH=/run/opengl-driver/lib:${lib.makeLibraryPath runtimeLibs}:$LD_LIBRARY_PATH
    export PATH=$PATH:${lib.makeBinPath runtimePrograms}
  '';
  XDG_DATA_DIRS = builtins.getEnv "XDG_DATA_DIRS";
  XDG_RUNTIME_DIR = builtins.getEnv "XDG_RUNTIME_DIR";
}
