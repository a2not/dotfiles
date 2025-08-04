{pkgs, ...}: {
  home.packages = with pkgs; [
    eza
    zoxide
    starship
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      l = "eza -lah --icons";
      ll = "eza -lah --icons";
      ls = "eza --icons";
    };
    history.size = 100000;
  };

  programs.starship = {
    enable = true;
    settings = {
      # Disable the blank line at the start of the prompt
      add_newline = false;
      # NOTE: hand-picked from color palette
      # https://github.com/enkia/tokyo-night-vscode-theme?tab=readme-ov-file#tokyo-night-and-tokyo-night-storm
      format = ''
        $os\
        [](fg:prev_bg bg:#414868)\
        $directory\
        [](fg:prev_bg bg:#343b58)\
        $git_branch\
        $git_status\
        [](fg:prev_bg bg:#24283b)\
        $git_metrics\
        [](fg:prev_bg bg:#1a1b26)\
        $nix_shell\
        [](fg:prev_bg)\
      '';
      right_format = ''
        [](fg:#24283b)\
        $cmd_duration\
        [](fg:#343b58 bg:#24283b)\
        $time
      '';

      os = {
        style = "fg:#cfc9c2 bg:#565f89";
        format = "[ $symbol]($style)";
        disabled = false;
        symbols = {
          Arch = " ";
          Debian = " ";
          Linux = " ";
          Macos = " ";
          NixOS = " ";
          Ubuntu = " ";
          Unknown = " ";
          Windows = " ";
        };
      };

      directory = {
        style = "fg:#b4f9f8 bg:prev_bg";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "fg:#e0af68 bg:prev_bg";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "fg:#e0af68 bg:prev_bg";
        format = "[$state($all_status$ahead_behind )]($style)";
        ahead = "⇡$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        behind = "⇣$count";
      };

      git_metrics = {
        added_style = "fg:#9ece6a bg:prev_bg";
        deleted_style = "fg:#f7768e bg:prev_bg";
        format = "([ +$added ]($added_style))([-$deleted ]($deleted_style))";
        disabled = false;
      };

      nix_shell = {
        style = "fg:#b4f9f8 bg:prev_bg";
      };

      python = {
        style = "fg:#9ece6a bg:prev_bg";
        format = "[$symbol$version\($virtualenv\)]($style)";
        symbol = "🐍";
        version_format = "$major.$minor";
      };

      cmd_duration = {
        min_time = 500;
        style = "fg:#b4f9f8 bg:#24283b";
        format = "[ $duration ]($style)";
        disabled = false;
      };

      time = {
        time_format = "%R";
        style = "fg:#a9b1d6 bg:#343b58";
        format = "[  $time ]($style)";
        disabled = false;
      };
    };
  };
}
