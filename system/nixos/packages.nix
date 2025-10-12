{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    git
    gnumake
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
