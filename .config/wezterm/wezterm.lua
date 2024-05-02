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

-- Configure Alt+arrow to move focus, Alt+Sh+arrow to adjust size, and Alt+Sh+w to close panes
config.keys = {
	{
		key = "LeftArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "DownArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "UpArrow",
		mods = "ALT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "LeftArrow",
		mods = "ALT|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Left", 1 }),
	},
	{
		key = "RightArrow",
		mods = "ALT|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Right", 1 }),
	},
	{
		key = "DownArrow",
		mods = "ALT|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Down", 1 }),
	},
	{
		key = "UpArrow",
		mods = "ALT|SHIFT",
		action = wezterm.action.AdjustPaneSize({ "Up", 1 }),
	},
	{
		key = "_",
		mods = "ALT|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "+",
		mods = "ALT|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "w",
		mods = "ALT|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
}

return config
