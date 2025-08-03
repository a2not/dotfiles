# TODO: mv to ./config/common.nix ?
# re think later when we use nix in ubuntu or nixos
{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alejandra

    neovim
    tmux

    ansible
    eza
    gnupg
    go
    just

    stow
    htop
    starship
    zoxide
  ];

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      max-jobs = 8;
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      interval = {
        Weekday = 0;
        Hour = 9;
        Minute = 0;
      };
      options = "--delete-older-than 7d";
    };
  };
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 5;
}
