# home-manager configuration

{config, pkgs, ...}: 
let
  shellAliases = {
    t = "tmux";
    ll = "ls -lhG";
    ls = "ls -G";
    l = "ls -G";
    g = "git";
    gst = "git status";
    gcm = "git commit -m";
    gca = "git commit --amend --no-edit";
    gcam = "git commit -am";
  };
in
{  
  home.packages = with pkgs; [ 
    neovim 
    nixd
    tmux
    git
    gh
    cargo
    pigz
  ];

  # for macos
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

  # for linux
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = shellAliases;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
