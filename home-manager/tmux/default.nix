{pkgs, ...}: {
  programs.tmux = {
    enable = true;
  };

  home.packages = with pkgs; [
    xclip
    xsel
  ];

  # home.file = {
  #   ".tmux.conf".source = ./.tmux.conf;
  # };
  xdg.configFile = {
    "tmux/tmux.conf".source = ./.tmux.conf;
  };
}
