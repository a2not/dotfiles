{pkgs, ...}: {
  home.packages = with pkgs; [
    delta
  ];

  programs.git = {
    enable = true;
  };

  home.file = {
    ".gitconfig".source = ./.gitconfig;
    ".gitconfig_work".source = ./.gitconfig_work;
  };
}
