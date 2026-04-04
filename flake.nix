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

  outputs = inputs@{ flake-parts, darwin, nixpkgs, ... }:
    let
      lib = inputs.nixpkgs.lib;
      hostsDir = ./hosts;
      # Directories to skip (non-NixOS hosts like nix-darwin)
      skipHosts = [ "macbookpro" ];
      hostDirs = builtins.attrNames (
        lib.filterAttrs (name: type:
          type == "directory"
          && !builtins.elem name skipHosts
          && builtins.pathExists (hostsDir + "/${name}/configuration.nix")
        ) (builtins.readDir hostsDir)
      );
      mkHost = name: lib.nixosSystem {
        modules = [ (hostsDir + "/${name}/configuration.nix") ];
      };
    in
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } ({ self, config, withSystem, moduleWithSystem, ... }: {
      imports = [
        ./shells/default.nix
        # Optional: use external flake logic, e.g.
        # inputs.foo.flakeModules.default
      ];

      flake = {
        nixosConfigurations = lib.genAttrs hostDirs mkHost;

        darwinConfigurations."kunafa" = darwin.lib.darwinSystem {
          modules = [
            ./hosts/macbookpro/configuration.nix
          ];

          specialArgs = { inherit nixpkgs self; };
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
