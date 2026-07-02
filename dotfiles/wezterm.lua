local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config = {
	font = wezterm.font_with_fallback({
		{ family = "MonacoLigaturized", weight = "Regular" },
		{ family = "JetBrains Mono", weight = "Regular" },
		{ family = "Ubuntu Mono Ligaturized" },
		{
			family = "ComicCodeLigatures NF",
			weight = "Light",
			italic = false,
			harfbuzz_features = { "calt=0", "clig=0" },
		},
		"手札体-简",
		"娃娃体-简",
		"Aa游龙行书",
	}),
	front_end = "WebGpu",
	font_size = 14,
	enable_scroll_bar = false,
	scrollback_lines = 10240,
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = false,
	automatically_reload_config = true,
	default_cursor_style = "BlinkingBar",
	initial_cols = 120,
	initial_rows = 35,
	use_fancy_tab_bar = true,
	tab_bar_at_bottom = false,
	show_new_tab_button_in_tab_bar = true,
	window_decorations = "RESIZE",
	window_background_opacity = 0.5,
	macos_window_background_blur = 30,
	text_background_opacity = 0.8,
	adjust_window_size_when_changing_font_size = false,
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 5,
	},
	color_scheme = "Panda (Gogh)",
	background = {
		-- {
		-- 	source = {
		-- 		File = "/Users/user/Wallpapers/c2s2d.png",
		-- 	},
		-- 	hsb = {
		-- 		brightness = 0.1,
		-- 		hue = 1.0,
		-- 		saturation = 1.02,
		-- 	},
		-- 	-- width = "100%",
		-- 	-- height = "100%",
		-- },
		{
			source = {
				Color = "#282c35",
			},
			width = "100%",
			height = "100%",
			opacity = 0.9,
		},
	},
	colors = {
		tab_bar = {
			background = "#16161d",
			active_tab = {
				-- bg_color = "#7e9cd8",
				bg_color = "#1f1f28",
				fg_color = "#ff007b",
			},
			inactive_tab = {
				bg_color = "#1f1f28",
				fg_color = "#8b949e",
			},
			inactive_tab_hover = {
				bg_color = "#484f58",
				fg_color = "#b1bac4",
			},
			new_tab = {
				bg_color = "#30363d",
				fg_color = "#8b949e",
			},
			new_tab_hover = {
				bg_color = "#484f58",
				fg_color = "#b1bac4",
			},
		},
		-- The color of the split lines between panes
		split = "#ff007b",
	},
	window_background_gradient = {
		orientation = { Linear = { angle = -60.0 } },
		interpolation = "CatmullRom",
		colors = {
			"#16161d",
			"#1a1b26",
			"#222436",
			"#24283b",
			"#30363d",
		},
		blend = "Rgb",
	},
}

return config
