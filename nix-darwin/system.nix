{...}: {
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
      # ];
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 1; # always
      ShowDayOfMonth = true;
      ShowDayOfWeek = true;
      ShowSeconds = true;
    };

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
    };

    trackpad.Clicking = true;

    universalaccess.reduceMotion = true;

    screencapture.location = "~/Pictures/screenshots";
  };
}
