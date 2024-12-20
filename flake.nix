{
  description = "Murad's Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = inputs@{ self, darwin, home-manager, nixpkgs-unstable, nixvim, ... }: {
    inherit self nixpkgs-unstable;

    darwinConfigurations."kunafa" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit self nixpkgs-unstable; };
      modules = [
        ./hosts/darwin/configuration.nix
        home-manager.darwinModules.home-manager
        nixvim.nixDarwinModules.nixvim
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };

    nixosConfigurations."andromeda" = nixpkgs-unstable.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit self nixpkgs-unstable; };
      modules = [
        ./hosts/vps/configuration.nix
        home-manager.nixosModules.home-manager
        nixvim.nixosModules.nixvim
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };
  };
}
