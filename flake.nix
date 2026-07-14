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
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    nix-wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    nix-wrapper-modules.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs =
    inputs@{
      flake-parts,
      darwin,
      nixpkgs,
      nix-wrapper-modules,
      ...
    }:
    let
      lib = inputs.nixpkgs.lib;
      hostsDir = ./hosts;
      # Hosts not built by the generic nixosSystem builder below: nix-darwin
      # hosts, and hosts needing a different builder (pi uses
      # nixos-raspberrypi.lib.nixosSystem).
      skipHosts = [
        "macbookpro"
        "pi"
      ];
      hostDirs = builtins.attrNames (
        lib.filterAttrs (
          name: type:
          type == "directory"
          && !builtins.elem name skipHosts
          && builtins.pathExists (hostsDir + "/${name}/configuration.nix")
        ) (builtins.readDir hostsDir)
      );
    in
    # https://flake.parts/module-arguments.html
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        self,
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      {
        imports = [
          ./shells/default.nix
          nix-wrapper-modules.flakeModules.wrappers
        ];

        flake = {
          nixosConfigurations =
            let
              mkHost =
                name:
                lib.nixosSystem {
                  modules = [ (hostsDir + "/${name}/configuration.nix") ];
                  specialArgs = { inherit self; };
                };
            in
            (lib.genAttrs hostDirs mkHost)
            // {
              # Raspberry Pi 5. Built with nixos-raspberrypi's own nixosSystem so
              # the vendor kernel/firmware overlays and cache are wired up.
              pi = inputs.nixos-raspberrypi.lib.nixosSystem {
                specialArgs = inputs // {
                  inherit self;
                };
                modules = [ ./hosts/pi/configuration.nix ];
              };
            };

          wrappers.neovim = import ./nvim/default.nix;

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

        perSystem =
          { config, pkgs, ... }:
          {
            formatter = pkgs.nixpkgs-fmt;
            # Recommended: move all package definitions here.
            # e.g. (assuming you have a nixpkgs input)
            # packages.foo = pkgs.callPackage ./foo/package.nix { };
            # packages.bar = pkgs.callPackage ./bar/package.nix {
            #   foo = config.packages.foo;
            # };
          };
      }
    );
}
