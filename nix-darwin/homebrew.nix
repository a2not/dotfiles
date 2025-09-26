{...}: {
  # TODO: we might not need nix-homebrew...
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = builtins.getEnv "USER";
    autoMigrate = true;
  };

  # NOTE: install homebrew beforehand
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
    ];

    # `brew install`
    brews = [
      "lima"
      "qemu"
    ];

    # `brew install --cask`
    casks = [
      "mos"
      "ghostty"
      "raycast"
      "google-chrome"
    ];
  };
}
