{...}: {
  # NOTE: install homebrew beforehand
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };

    brews = [
      "lima"
      "qemu"
    ];

    casks = [
      "1password"
      "1password-cli"
      "discord"
      "ghostty"
      "gitify"
      "google-chrome"
      "karabiner-elements"
      "mos"
      "notion"
      "raycast"
      "spotify"
      "vial"
      "wezterm"
      "zen"
    ];
  };
}
