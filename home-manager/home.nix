{
  inputs,
  username,
  homeDirectory,
}: {
  pkgs,
  config,
  ...
}: let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in {
  home.stateVersion = "25.05";

  home.username = username;
  home.homeDirectory = homeDirectory;

  # NOTE: non-NixOS GPU access is annoying. I'm using this only on NixOS anyway, so it's okay to disable genericLinux.
  # https://github.com/nix-community/home-manager/commit/d8efc4bfa764676af1fec08f99ce9450d21f2d47
  # targets.genericLinux.enable = isLinux;

  home.packages = with pkgs; [
    nixVersions.latest
    sops
    htop

    just
    go
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
  };

  imports = [
    ./zsh
    ./git
    ./ssh
    ./tmux
    ./neovim

    ./gui
  ];

  home.shell.enableZshIntegration = true;

  xdg.enable = true;

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt"; # set keys on new host
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  nix.gc = {
    automatic = true;
    dates = "daily";
    persistent = true;
  };
}
