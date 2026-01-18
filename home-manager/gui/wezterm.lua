local wezterm = require("wezterm")
local mux = wezterm.mux
local config = wezterm.config_builder()

config.automatically_reload_config = true

config.color_scheme = "tokyonight_night"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font_with_fallback({
	"UDEV Gothic 35NF",
	"MesloLGM Nerd Font",
})
config.line_height = 1.1
config.font_size = 18
config.use_ime = true

return config
