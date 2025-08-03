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

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 5;

  modules = [
    ./lib/nix.nix
  ];
  specialArgs = {
    inherit pkgs;
  };
}
