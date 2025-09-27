{...}: {
  # NOTE: this is needed only on host but no harm having inside VM so keeping this unconditionally
  # TODO: may want to move to system config, not home-manager since it's host only
  xdg.configFile = {
    "ghostty/config".source = ./ghostty_config;
    "wezterm/wezterm.lua".source = ./wezterm.lua;
  };
}
