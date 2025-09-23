{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    eza
    starship
    zoxide
    ripgrep

    mise
    aider-chat
  ];

  # NOTE: for the conditionals in .zshrc
  home.sessionVariables = {
    IS_NIX_HOME_MANAGED = "heck yeah!";
  };

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
      '';
    };
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -lah --icons";
      update = "sudo apt update && sudo apt upgrade -y && sudo snap refresh"; # ubunbu update
      aider = "aider --no-show-model-warnings --no-auto-commits";
    };
    history.size = 100000;
    # https://discourse.nixos.org/t/programs-neovim-defaulteditor-true-kills-bindkey-for-autosuggest-accept-in-zsh/48844
    defaultKeymap = "emacs";

    initContent = ''
      ${builtins.readFile ./.zshrc}

      source ${config.xdg.configHome}/zsh/.zshrc_aider
      source ${config.sops.secrets."work/zshrc".path}
    '';
  };

  sops = {
    secrets = {
      "aider/model" = {};
      "aider/openai/api_base" = {};
      "aider/openai/api_key" = {};

      "work/zshrc" = {};
    };
    templates = {
      "aider" = {
        content = ''
          export AIDER_MODEL=${config.sops.placeholder."aider/model"}
          export OPENAI_API_BASE=${config.sops.placeholder."aider/openai/api_base"}
          export OPENAI_API_KEY=${config.sops.placeholder."aider/openai/api_key"}
        '';
        path = "${config.xdg.configHome}/zsh/.zshrc_aider";
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
