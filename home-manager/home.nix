{
  inputs,
  username,
  homeDirectory,
}: {
  pkgs,
  config,
  ...
}: {
  _module.args.inputs = inputs;

  home.stateVersion = "25.05";
  # TODO: next time we build new NixOS
  # home.stateVersion = "25.11";

  home.username = username;
  home.homeDirectory = homeDirectory;

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
    ./agent

    ./gui
  ];

  home.shell.enableZshIntegration = true;

  xdg.enable = true;

  sops = {
    age.keyFile = "/var/lib/sops-nix/keys.txt";
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
