{
  description = "Murad's dotfiles";

  inputs = {
    colmena.url = "github:zhaofengli/colmena";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:LnL7/nix-darwin";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs@{ flake-parts, ... }:
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } (top@{ config, withSystem, moduleWithSystem, ... }: {
      imports = [
        ./shells/default.nix
        # Optional: use external flake logic, e.g.
        # inputs.foo.flakeModules.default
      ];
      flake = {

        nixosConfigurations."lxc-template" = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/lxc-shared.nix
            {
#              nixpkgs.buildPlatform = "aarch64-darwin";
            }
          ];
        };
      };
      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        # ...
      ];
      perSystem = { config, pkgs, ... }: {
        formatter = pkgs.nixpkgs-fmt;
        # Recommended: move all package definitions here.
        # e.g. (assuming you have a nixpkgs input)
        # packages.foo = pkgs.callPackage ./foo/package.nix { };
        # packages.bar = pkgs.callPackage ./bar/package.nix {
        #   foo = config.packages.foo;
        # };
      };
    });
}
