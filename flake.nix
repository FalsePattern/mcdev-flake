{
  description = "Minecraft Development flake";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    with builtins;
    let
      genPairs = mcVersions: javaVersions: concatLists (map (mc: map (java: { inherit mc java; }) javaVersions) mcVersions);
      knownVersions = genPairs [ "1.7.10" ] [ "8" ];
      toJavaPkg = version: "temurin-bin-${version}";
      getSupportedVersions = pkgs: map (version: version // { java_pkg = pkgs.${toJavaPkg version.java}; }) (filter (version: pkgs ? ${toJavaPkg version.java}) knownVersions);
      versionString = version: "${version.mc}-java${version.java}";

      isLinux = system: builtins.match ".*linux.*" system != null;
      linuxSystems = builtins.filter isLinux flake-utils.lib.defaultSystems;
      output = flake-utils.lib.eachSystem linuxSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          supportedVersions = getSupportedVersions pkgs;
          mapVersions = nameCreator: valueCreator:
            listToAttrs (
              map
                (version: {
                  name = nameCreator version;
                  value = valueCreator version;
                }
                )
                supportedVersions
            );

          devShellEntry = version: import ./shell.nix { inherit pkgs version; };
          packageEntry = version: import ./wrapper.nix {
            inherit pkgs;
            devShell = versionString version;
            name = "mcdev_${versionString version}";
          };
        in
        {
          devShells = mapVersions versionString devShellEntry;
          packages = mapVersions versionString packageEntry;
        }
      );
    in
    output // {
      overlays.default = final: prev: {
        mcdev = output.packages.${prev.system};
      };
    };
}
