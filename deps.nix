# Where the magic happens.
{
  pkgs,
  lib ? pkgs.lib,
  version,
  addDriverRunpath ? pkgs.addDriverRunpath,
  additionalLibs ? [ ],
  additionalPrograms ? [ ]
}:
let
  importPkg = path: pkgs.callPackage path { inherit pkgs; };

  openal64 = importPkg ./packages/openal64.nix;

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

  runtimeLibs = x11Deps ++ lwjglDeps ++ oshiDeps ++ [ version.java_pkg ] ++ additionalLibs;
  runtimePrograms = with pkgs; [
    xorg.xrandr
    mesa-demos # need glxinfo
  ] ++ additionalPrograms;
in
{
  inputs = runtimeLibs ++ runtimePrograms;
  LD_LIBRARY_PATH = "${addDriverRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}";
  PATH = lib.makeBinPath runtimePrograms;
  XDG_DATA_DIRS = builtins.getEnv "XDG_DATA_DIRS";
  XDG_RUNTIME_DIR = builtins.getEnv "XDG_RUNTIME_DIR";
}