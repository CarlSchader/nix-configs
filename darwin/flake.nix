{
  description = "Carl's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Add home-manager configuration here
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.carlschader = { pkgs, ... }: {
          home.packages = [ 
            pkgs.neovim 
            pkgs.nixd
            pkgs.tmux
            pkgs.git
            pkgs.gh
            pkgs.cargo
            pkgs.pigz
          ];

          programs.zsh = {
            enable = true;
            enableCompletion = true;
            initExtra = ''
              autoload -U colors && colors
              PS1="%{$fg[green]%}%n%{$reset_color%}@%{$fg[green]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
              eval 'ssh-agent -s'
              ssh-add ~/.ssh/id_ed25519
            '';
            shellAliases = {
              t = "tmux";
              ll = "ls -lhG";
              ls = "ls -G";
              l = "ls -G";
            };
          };

          home.stateVersion = "24.11";
        };
      };

      # User configuration
      users.users.carlschader = {
        name = "carlschader";
        home = "/Users/carlschader";
      };
    };
    configuration-work = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ 
        pkgs.vim
        pkgs.tailscale
      ];

      services.tailscale = {
        enable = true;
        # interfaceName = "userspace-networking";
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Add home-manager configuration here
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.carlschader = { pkgs, ... }: {
          home.packages = [ 
            pkgs.neovim 
            pkgs.nixd
            pkgs.tmux
            pkgs.git
            pkgs.gh
            pkgs.cargo
            pkgs.pigz
          ];

          programs.zsh = {
            enable = true;
            enableCompletion = true;
            initExtra = ''
              autoload -U colors && colors
              PS1="%{$fg[green]%}%n%{$reset_color%}@%{$fg[green]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
              eval 'ssh-agent -s'
              ssh-add ~/.ssh/id_ed25519
            '';
            shellAliases = {
              t = "tmux";
              ll = "ls -lhG";
              ls = "ls -G";
              l = "ls -G";
            };
          };

          home.stateVersion = "24.11";
        };
      };

      # User configuration
      users.users.carlschader = {
        name = "carlschader";
        home = "/Users/carlschader";
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Carls-MacBook-Pro-2
    darwinConfigurations."Carls-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        home-manager.darwinModules.home-manager
      ];
    };

    darwinConfigurations."Carls-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration-work
        home-manager.darwinModules.home-manager
      ];
    };
  };
}
