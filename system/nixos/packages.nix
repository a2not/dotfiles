{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    git
    gnumake
    zsh
  ];

  users.defaultUserShell = pkgs.zsh;
}
