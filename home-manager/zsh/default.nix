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

    mise

    nur.repos.charmbracelet.crush
    opencode
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
  };

  sops = {
    secrets = {
      "openai/api_key" = {};

      "work/zshrc" = {};
    };
    templates = {
      "crush" = {
        content = ''
          {
            "$schema": "https://charm.land/crush.json",
            "providers": {
              "qwen": {
                "type": "openai",
                "base_url": "https://api.ai.sakura.ad.jp/v1",
                "api_key": "${config.sops.placeholder."openai/api_key"}",
                "models": [
                  {
                    "name": "qwen3",
                    "id": "Qwen3-Coder-480B-A35B-Instruct-FP8",
                    "context_window": 256000,
                    "default_max_tokens": 20480
                  }
                ]
              }
            }
          }
        '';
        path = "${config.xdg.configHome}/crush/crush.json";
      };
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
