{
  description = "Murad's Infrastructure Platform";

  inputs = {
    colmena.url = "github:zhaofengli/colmena";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:LnL7/nix-darwin";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.url = "github:nix-community/nixos-generators";
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
        nixosModules = {
          core = ./modules/core;
          hardware = ./modules/hardware;
        };
        nixosConfigurations = 
          let
            mkHost = import ./lib/mkHost.nix { inherit inputs; };
            discoverHosts = import ./lib/host-discovery.nix { inherit inputs mkHost; };
          in
          discoverHosts { baseDir = ./hosts/virtual; };
        
        colmena = import ./lib/mkColmena.nix { inherit inputs; } { baseDir = ./hosts/virtual; };
      };
      systems = [
        # systems for which you want to build the `perSystem` attributes
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        # ...
      ];
      perSystem = { config, pkgs, system, self', ... }: {
        formatter = pkgs.nixpkgs-fmt;
        
        packages = if system == "x86_64-linux" then {
          lxc-image = inputs.nixos-generators.nixosGenerate {
            inherit pkgs;
            format = "proxmox-lxc";
            modules = [
              ./hosts/bootstrap/lxc/default.nix
            ];
          };
        } else {};

        # Recommended: move all package definitions here.
        # e.g. (assuming you have a nixpkgs input)
        # packages.foo = pkgs.callPackage ./foo/package.nix { };
        # packages.bar = pkgs.callPackage ./bar/package.nix {
        #   foo = config.packages.foo;
        # };
      };
    });
}
