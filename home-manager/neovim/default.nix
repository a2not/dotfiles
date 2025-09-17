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
    extraPackages = with pkgs; [
      lua-language-server
      nodePackages.typescript-language-server
      gopls
      nil
      stylua
    ];
    # plugins = with pkgs.vimPlugins; [lazy-nvim];
  };

  xdg.configFile."nvim" = {
    source = "${config.home.homeDirectory}/nix-config/home-manager/neovim/nvim";
  };
}
