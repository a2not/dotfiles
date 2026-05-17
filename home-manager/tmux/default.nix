{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = with pkgs; [
      tmuxPlugins.tokyo-night-tmux
    ];
  };

  home.packages = with pkgs; [
    xclip
    xsel
  ];
}
