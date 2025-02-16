# home-manager configuration

{config, pkgs, ...}: 
let
  shellAliases = {
    n = "nvim";
    t = "tmux";
    ll = "ls -lhG";
    ls = "ls -G";
    l = "ls -G";
    g = "grep";
    k = "kubectl";
    tarz = "tar --zstd";
    venv = "source .venv/bin/activate";
  };
in {  
  home.packages = with pkgs; [ 
    ## user applications
    brave

    ## dev tools
    tmux
    neovim
    gh
    wezterm
    ripgrep
    awscli2
    kubectl
    jq
    zstd
    unzip
    pigz
    virtualenv
    mediainfo
    ffmpeg

    ## compilers and runtimes
    nodejs_23
    cargo
    python310
    go

    ## lsps
    nixd
    rust-analyzer
    pyright
    typescript-language-server
  ];

  # programs.nixvim = import ./nixvim.nix { inherit pkgs; };

  programs.git = {
    enable = true;
    userName = "Carl Schader";
    userEmail = "carl.schader@saronic.com";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      autoload -U colors && colors
      PS1="%{$fg[green]%}%n%{$reset_color%}@%{$fg[green]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
      eval 'ssh-agent -s'
      ssh-add ~/.ssh/id_ed25519
      export EDITOR=nvim
    '';
    shellAliases = shellAliases;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = shellAliases;
    initExtra = ''
      eval 'ssh-agent -s'
      ssh-add ~/.ssh/id_ed25519
      export EDITOR=nvim
    '';
  };

  nix.registry.configs = {
    from = {
      id = "configs";
      type = "indirect";
    };
    to = {
      owner = "CarlSchader";
      repo = "nix-configs";
      type = "github";
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
