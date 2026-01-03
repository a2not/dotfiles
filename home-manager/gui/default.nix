{config, ...}: {
  # NOTE: this is needed only on host but no harm having inside VM so keeping this unconditionally
  # TODO: may want to move to system config, not home-manager since it's host only
  xdg.configFile = {
    "ghostty/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/gui/ghostty_config";

    "wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/gui/wezterm.lua";
  };
}
