{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_theme night
          set -g @tokyo-night-tmux_transparent 1
          set -g @tokyo-night-tmux_window_id_style none
          set -g @tokyo-night-tmux_pane_id_style hide
          set -g @tokyo-night-tmux_zoom_id_style hide
          set -g @tokyo-night-tmux_window_tidy_icons 1
        '';
      }
    ];
  };

  home.packages = with pkgs; [
    xclip
    xsel
  ];
}
