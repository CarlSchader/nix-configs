# home-manager configuration

{config, pkgs, ...}: 
let
  shellAliases = {
    t = "tmux";
    ll = "ls -lhG";
    ls = "ls -G";
    l = "ls -G";
    g = "grep";
    k = "kubectl";
    tarz = "tar --zstd";
  };
in {  
  home.packages = with pkgs; [ 
    neovim 
    nixd
    tmux
    git
    gh
    cargo
    pigz
    wezterm
    ripgrep
    awscli2
    brave
    kubectl
    jq
    zstd
    python313
    tree-sitter
  ];

  # programs.openssh = {
  #   enable = true;
  #   authorizedKeys = [
  #
  #   ];
  # };

  programs.git = {
    enable = true;
    userName = "Carl Schader";
    userEmail = "carlschader@gmail.com";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      autoload -U colors && colors
      PS1="%{$fg[green]%}%n%{$reset_color%}@%{$fg[green]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "
      eval 'ssh-agent -s'
      ssh-add ~/.ssh/id_ed25519
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
    '';
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
