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

    withPython3 = true;
    withNodeJs = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      lazy-nvim
      telescope-fzf-native-nvim
    ];

    extraPackages = with pkgs; [
      zig
      gcc
      gnumake
      go

      fzf
      ripgrep

      golangci-lint
      lua-language-server
      gopls
      nil
      stylua
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home-manager/neovim/nvim";
  };
  # TODO: migrate lazy.nvim setup to nix
  # xdg.configFile = {
  #   "nvim" = {
  #     source = ./nvim;
  #     recursive = true;
  #   };
  # };
}
