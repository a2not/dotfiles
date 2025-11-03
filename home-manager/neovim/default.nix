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
    ];

    extraPackages = with pkgs; [
      gcc
      cmake
      gnumake
      unzip

      alejandra
      nil
      nixd
      stylua
      lua-language-server

      go
      golangci-lint
      cargo
      python3

      fd
      fzf
      ripgrep
    ];
  };

  home.packages = with pkgs; [
    gcc # CGO
    nodejs_24 # npx
    pnpm
    go
    gopls
  ];

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/neovim/nvim";
    recursive = true;
  };
}
