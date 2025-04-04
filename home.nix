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

    # git aliases
    gfa = "git fetch --all";
    ga = "git add .";
    gca = "git commit -am";
    gp = "git push";
    gpl = "git pull";
    gs = "git switch";

    tarz = "tar --zstd";
    venv = "source .venv/bin/activate";
    bw-login = "export $(bw login | sed -En '4p' | awk '{print $3}')";
  };
in {  
  home.packages = with pkgs; [ 
    ## user applications
    brave

    ## dev tools
    tmux
    neovim
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
    postgresql_17
    nmap
    pnpm
    gnumake

    ## compilers and runtimes
    nodejs_23
    gcc
    cargo
    python310
    go
    docker_26
    jdk23

    ## lsps
    nixd
    rust-analyzer
    pyright
    python312Packages.python-lsp-server
    typescript-language-server
    lua-language-server

    # linters
    ruff
  ];

  # programs.nixvim = import ./nixvim.nix { inherit pkgs; };

  # # Disabled because it's easier to just set this per user since this home config is used by multiple users
  # programs.git = {
  #   enable = true;
  #   userName = "Carl Schader";
  #   userEmail = "carl.schader@saronic.com";
  # };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      autoload -U colors && colors
      PS1="%{$fg[green]%}%n%{$reset_color%}@%{$fg[green]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
      eval $(ssh-agent -s)
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
      eval $(ssh-agent -s)
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
