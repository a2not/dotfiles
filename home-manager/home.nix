{inputs}: {
  homeDirectory,
  username,
}: {pkgs, ...}: let
  # system = pkgs.system;
  # isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  # isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
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
    neovim
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "${homeDirectory}/.config";
    XDG_CACHE_HOME = "${homeDirectory}/.cache";
    XDG_DATA_HOME = "${homeDirectory}/.local/share";
    XDG_STATE_HOME = "${homeDirectory}/.local/state";
    EDITOR = "nvim";
    VISUAL = "nvim";
    MANPAGER = "nvim +Man!";
  };

  imports = [
    ./zsh
    ./git
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
