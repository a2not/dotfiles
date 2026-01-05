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
      avante-nvim
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
      rust-analyzer
      rustfmt
      python3
      terraform

      fd
      fzf
      ripgrep
    ];
  };

  home.packages = with pkgs; [
    go
    gopls

    zig

    gcc # CGO

    nodejs_24 # npx
    pnpm

    cargo
    rustc
  ];

  # ocaml
  # programs.opam = {
  #   enable = true;
  #   enableZshIntegration = true;
  # };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/neovim/nvim";
    recursive = true;
  };
}
