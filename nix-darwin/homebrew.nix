{...}: {
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
