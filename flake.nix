{
  description = "main flake for all my configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nix-darwin, nixpkgs, home-manager, ... }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Carls-MacBook-Pro-2
    darwinConfigurations."Carls-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
      modules = [ 
        ./darwin.nix
        home-manager.darwinModules.home-manager
      ];
    };

    # work laptop
    darwinConfigurations."Carls-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      specialArgs = {
        custom-packages = [ tailscale ];
      };
      modules = [ 
        ./darwin.nix
        home-manager.darwinModules.home-manager
      ];
    };

    nixosConfigurations.ml-pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./x86/ml-pc-configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.carlschader = import ./home.nix;
        }
      ];
    };

  };
}
