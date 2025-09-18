{pkgs, ...}: {
  programs.tmux = {
    enable = true;
  };

  home.packages = with pkgs; [
    xclip
    xsel
  ];

  xdg.configFile."tmux/tmux.conf" = {
    ".gitconfig".source = ./.tmux.conf;
  };
}
