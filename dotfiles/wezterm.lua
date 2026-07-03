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
	-- Gruvbox Material Dark — 与 Ghostty / tmux 配色统一
	-- 调色板参考: https://github.com/sainnhe/gruvbox-material
	color_scheme = "Gruvbox Material (Gogh)",

	-- 纯色背景 + 半透明（与 Ghostty 窗口背景 #1d2021 一致）
	background = {
		{
			source = {
				Color = "#1d2021",
			},
			width = "100%",
			height = "100%",
			opacity = 0.88,
		},
	},

	-- 状态栏配色（与 tmux 状态栏风格统一）
	colors = {
		tab_bar = {
			background = "#1d2021",
			active_tab = {
				bg_color = "#504945",
				fg_color = "#d4be98",
			},
			inactive_tab = {
				bg_color = "#1d2021",
				fg_color = "#928374",
			},
			inactive_tab_hover = {
				bg_color = "#3c3836",
				fg_color = "#d4be98",
			},
			new_tab = {
				bg_color = "#1d2021",
				fg_color = "#928374",
			},
			new_tab_hover = {
				bg_color = "#3c3836",
				fg_color = "#d4be98",
			},
		},
		-- 分屏分割线
		split = "#504945",
	},

	-- 微妙的背景渐变（Gruvbox Material Dark 色阶）
	window_background_gradient = {
		orientation = { Linear = { angle = -60.0 } },
		interpolation = "CatmullRom",
		colors = {
			"#1d2021",
			"#282828",
			"#32302f",
			"#3c3836",
		},
		blend = "Rgb",
	},
}

return config
