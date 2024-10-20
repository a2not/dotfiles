{pkgs, ...}: {
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;

    # TODO: check
    # https://mynixos.com/nix-darwin/options/system.defaults
    # https://daiderd.com/nix-darwin/manual/index.html
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    dock = {
      autohide = true;
      # persistent-apps = [
      #   "${pkgs.arc}/Applications/Arc.app"
      #   "${pkgs.WezTerm}/Applications/WezTerm.app"
      #   "${pkgs.Slack}/Applications/Slack.app"
      #   "${pkgs.Zoom}/Applications/zoom.us.app"
      #   "${pkgs.OnePassword}/Applications/1Password.app"
      #   "${pkgs.Spotify}/Applications/Spotify.app"
      # ];
      show-recents = false;
      tilesize = 50;
      orientation = "bottom";
      mineffect = "scale";
      launchanim = false;
    };

    screencapture.location = "~/Pictures/screenshots";
  };
}
