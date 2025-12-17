{
  pkgs,
  config,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  home.packages = with pkgs; [
    eza
    starship
    zoxide
    ripgrep
    fastfetch

    devenv

    mise

    opencode
    crush
    amp
    bash # AI agent needs this

    terraform
    gopls
    rust-analyzer
    typescript-language-server
    phpactor
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true; # plugin "zsh-autosuggestions"
    syntaxHighlighting.enable = true; # plugin "zsh-syntax-highlighting"
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
      extraConfig = ''
        zstyle ':omz:update' mode auto
        zstyle ':omz:update' verbose minimal
        ${
          if isDarwin
          then ''
            # NOTE: MacOS specific
            export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
            if [[ $(uname -m) == 'arm64' ]]; then
              eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
          ''
          else ""
        }
      '';
    };
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -lah --icons";
      update = "sudo apt update && sudo apt upgrade -y && sudo snap refresh"; # ubunbu update
    };
    history.size = 100000;
    # https://discourse.nixos.org/t/programs-neovim-defaulteditor-true-kills-bindkey-for-autosuggest-accept-in-zsh/48844
    defaultKeymap = "emacs";

    initContent = ''
      ${builtins.readFile ./.zshrc}

      export OPENAI_API_KEY="$(cat ${config.sops.secrets."openai/api_key".path})"

      source ${config.sops.secrets."work/zshrc".path}
    '';
  };

  xdg.configFile = {
    "opencode/opencode.json".source = ./opencode.json;
    "crush/crush.json".source = ./crush.json;
  };

  sops = {
    secrets = {
      "openai/api_key" = {};

      "work/zshrc" = {};
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig = {
      tools = {
        node = "lts";
        python = "latest";
        uv = "latest";
      };
    };
  };
}
