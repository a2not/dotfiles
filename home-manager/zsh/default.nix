{
  pkgs,
  config,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  pnpmHome = "${config.home.homeDirectory}/.local/share/pnpm";
in {
  home.packages = with pkgs; [
    fzf
    eza
    starship
    zoxide
    ripgrep
    fastfetch
    jq
    gh

    devenv

    mise
    gnupg

    llm-agents.opencode
    llm-agents.fence
    llm-agents.claude-code
    llm-agents.pi
    bash # AI agent needs this

    terraform
    gopls
    golangci-lint
    rust-analyzer
    typescript-language-server
    bun
    phpactor
    python3
  ];

  # make it available to `pnpm install --global`
  home.sessionVariables = {
    PNPM_HOME = pnpmHome;
  };
  home.sessionPath = [
    "${pnpmHome}/bin/"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true; # plugin "zsh-autosuggestions"
    syntaxHighlighting.enable = true; # plugin "zsh-syntax-highlighting"
    # NOTE: omz gives me sane defaults. For example, I prefer "{up,down}-line-or-beginning-search" keybindings to enabling zsh-history-substring-search.
    oh-my-zsh.enable = true;

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -lah --icons";
      update = "sudo apt update && sudo apt upgrade -y && sudo snap refresh"; # ubunbu update
      # opencode = "fence opencode";
    };
    history = {
      append = true;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      ignoreDups = true;
      save = 10000;
      saveNoDups = true;
      share = true;
      size = 10000;
    };
    # https://discourse.nixos.org/t/programs-neovim-defaulteditor-true-kills-bindkey-for-autosuggest-accept-in-zsh/48844
    defaultKeymap = "emacs";

    profileExtra =
      if isDarwin
      then ''
        # NOTE: MacOS specific
        export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
        if [[ $(uname -m) == 'arm64' ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      ''
      else "";

    initContent =
      ''
        export OPENAI_API_KEY="$(cat ${config.sops.secrets."openai/api_key".path})"
        source ${config.sops.secrets."work/zshrc".path}
      ''
      + builtins.readFile ./.zshrc;

    # NOTE: align with new default value from home.stateVersion >= 26.05
    dotDir = "${config.xdg.configHome}/zsh";
  };

  xdg.configFile = {
    "opencode" = {
      source = ./opencode;
      recursive = true;
    };
    "fence/fence.jsonc" = {
      source = ./fence/fence.jsonc;
    };
  };

  home.file = {
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/zsh/pi/agent/settings.json";
    ".pi/agent/models.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/zsh/pi/agent/models.json";
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };
}
