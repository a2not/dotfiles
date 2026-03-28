{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vim
    git
    gnumake
  ];

  # set zsh as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [zsh];

  # enable docker
  virtualisation.docker.enable = true;
  virtualisation.docker.extraPackages = with pkgs; [
    docker-buildx
    docker-compose
  ];

  # enable nix-ld, i feel defeated i know...
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };
}
