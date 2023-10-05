# HOW TO USE

## As a package overlay
1. Add `mcdev.url = "github:falsepattern/mcdev-flake"` to your flake inputs
2. Add the `inputs.mcdev.overlays.default` overlay to your system config
3. Access the packages in your packages. For instance: `mcdev."1.7.10-java8"` in your dependencies

## As a standalone flake
- Use `nix flake show` to list available devshells. You can use the devshells using `nix develop .#DEVSHELL`

## Available versions and contributing
Currently, this flake has support for:

| Minecraft version | LWJGL version | Java Version |
|-------------------|---------------|--------------|
| 1.7.10            | 2.9.4         | 8            |

 Feel free to contribute other version combinations if you have validated that they work properly

# Can I fork this?
This project is MIT-licensed, so feel free. Just please keep the license notice and attribution.