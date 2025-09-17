{
  pkgs,
  config,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      telescope-fzf-native-nvim
    ];

    extraPackages = with pkgs; [
      nodejs
      nodePackages.neovim
      fzf
      zig
      gcc
      gnumake
      go
      golangci-lint

      lua-language-server
      nodePackages.typescript-language-server
      gopls
      nil
      stylua
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home-manager/neovim/nvim";
  };
}
