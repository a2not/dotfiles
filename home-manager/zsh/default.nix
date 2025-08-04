{pkgs, ...}: {
  home.packages = with pkgs; [
    eza
    starship
    zoxide
    ripgrep

    mise
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
    initContent = ''
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
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
      };
    };
  };
}
