{inputs}: {
  homeDirectory,
  username,
}: {pkgs, ...}: let
  # isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  # isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  system = pkgs.system;
in {
  home.stateVersion = "25.05";

  home.username = username;
  home.homeDirectory = homeDirectory;

  targets.genericLinux.enable = isLinux;

  # TODO: only on darwin
  # home.file.".config/ghostty/config".text = ''
  #   # settings
  #   background-opacity = 0.95
  #   font-family = GeistMono NFM
  #   font-size = 18
  #   macos-option-as-alt = true
  #   theme = TokyoNight
  # '';

  home.packages = with pkgs; [
    nixVersions.latest
    just
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
  };

  imports = [
    ./zsh
    ./git
    ./tmux
    ./neovim
  ];

  home.shell.enableZshIntegration = true;

  xdg.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
