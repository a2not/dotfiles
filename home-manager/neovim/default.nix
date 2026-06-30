{
  lib,
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
    withRuby = false;

    # NOTE: to prevent neovim module to create init.lua. I have my own definition.
    sideloadInitLua = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      lazy-nvim
    ];

    extraPackages = with pkgs; [
      gcc
      cmake
      gnumake
      unzip

      copilot-language-server

      alejandra
      nil
      nixd
      stylua
      lua-language-server

      go
      gopls
      gotools
      gofumpt
      golangci-lint
      golangci-lint-langserver
      cargo
      rust-analyzer
      rustfmt
      python3
      basedpyright
      ruff
      terraform
      terraform-ls
      tflint

      zls
      typespec
      intelephense

      vscode-langservers-extracted
      typescript-language-server

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
  };
}
