# HOW TO USE

## As a package overlay
1. Add `mcdev.url = "github:falsepattern/mcdev-flake"` to your flake inputs
2. Add the `inputs.mcdev.overlays.default` overlay to your system config
3. Access the packages in your packages. For instance: `mcdev."1.7.10-java8"` in your dependencies

## As a standalone flake
- Use `nix flake show` to list available devshells. You can use the devshells using `nix develop .#DEVSHELL`

# Can i fork this?
This project is MIT-licensed, so feel free. Just please keep the license notice and attribution.