-- Pull in the actual config
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "GruvboxDark"
config.hide_tab_bar_if_only_one_tab = true
config.font_size = 11

-- Set background to an image that scales to the height of the window
-- and sticks to the left
config.background = {
	{
		source = {
			File = "/home/dknel/Pictures/backgrounds/EROS-Wallpaper-WEB.png",
		},
		attachment = "Fixed",
		height = "100%",
		hsb = {
			brightness = 0.2,
		},
	},
}

config.inactive_pane_hsb = {
	saturation = 0.7,
	brightness = 0.3,
}
return config
