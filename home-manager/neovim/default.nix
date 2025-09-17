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
      gcc
      cmake
      gnumake
      unzip

      go
      cargo
      python3

      fd
      fzf
      ripgrep
    ];
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home-manager/neovim/nvim";
    recursive = true;
  };
}
