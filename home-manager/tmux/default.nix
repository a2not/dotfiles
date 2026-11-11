{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.minimal-tmux-status;
        extraConfig = ''
          set -g @minimal-tmux-justify "left"
        '';
      }
    ];
  };

  home.packages = with pkgs; [
    xclip
    xsel
  ];
}
