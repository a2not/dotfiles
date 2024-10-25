{pkgs, ...}: {
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    # NOTE: https://mynixos.com/nix-darwin/options/system.defaults
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
      tilesize = 64;
      orientation = "bottom";
      mineffect = "scale";
      launchanim = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
    };

    screencapture.location = "~/Pictures/screenshots";
  };
}
