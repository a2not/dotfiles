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
    # https://discourse.nixos.org/t/programs-neovim-defaulteditor-true-kills-bindkey-for-autosuggest-accept-in-zsh/48844
    defaultKeymap = "emacs";

    # TODO: Existing file '$HOME/.zshrc' would be clobbered
    # # Lima BEGIN
    # # Make sure iptables and mount.fuse3 are available
    # PATH="$PATH:/usr/sbin:/sbin"
    # export PATH
    # # Lima END
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
