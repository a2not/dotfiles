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
    enableZshIntegration = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };
}
