{
  description = "Minecraft Development flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    with builtins;
    let
      knownVersions = [
        {
          mc = "1.7.10";
          java = "8";
        }
        {
          mc = "rdn";
          java = "21";
        }
      ];
      toJavaPkg = version: "jdk${version}";
      getSupportedVersions = system: pkgs: map
        (version: version // { java_pkg = pkgs.${toJavaPkg version.java}; })
        (filter (version:
           let
             pkgName = toJavaPkg version.java;
             hasPackage = pkgs ? ${pkgName};
             result = if hasPackage then
                        true
                      else
                        trace "Could not find package ${pkgName} on system ${system}!" false;
           in result) knownVersions);
      versionString = version: "${version.mc}-java${version.java}";

      isLinux = system: match ".*linux.*" system != null;
      linuxSystems = filter isLinux flake-utils.lib.defaultSystems;
      output = flake-utils.lib.eachSystem linuxSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          supportedVersions = getSupportedVersions system pkgs;
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

          devShellEntry = version: import ./shell.nix {
            inherit pkgs version;
          };
          packageEntry = version: pkgs.callPackage ./wrapper.nix {
            inherit pkgs version;
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
        mcdev = output.packages.${prev.stdenv.hostPlatform.system};
      };
    };
}
