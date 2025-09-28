{
  inputs,
  username,
  homeDirectory,
}: {
  pkgs,
  config,
  ...
}: let
  # system = pkgs.system;
  # isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in {
  home.stateVersion = "25.05";

  home.username = username;
  home.homeDirectory = homeDirectory;

  targets.genericLinux.enable = isLinux;

  home.packages = with pkgs; [
    nixVersions.latest
    just

    sops

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

    ./terminal-emulator
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
