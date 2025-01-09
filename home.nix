# home-manager configuration

{config, pkgs, ...}: {
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
      test-echo = "echo 'Hello, World!'";
    };
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
