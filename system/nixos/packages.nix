{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    git
    gnumake
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [zsh];

  virtualisation.docker.enable = true;

  virtualisation.docker.extraPackages = with pkgs; [
    docker-buildx
    docker-compose
  ];
}
