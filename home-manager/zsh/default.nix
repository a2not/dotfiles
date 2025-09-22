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

      source ${config.sops.secrets."aider/zshrc".path}
      source ${config.sops.secrets."work/zshrc".path}
    '';
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
