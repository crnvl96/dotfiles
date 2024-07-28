local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

-- Support for undercurl, etc.
config.term = "wezterm"
config.font = wezterm.font("BerkeleyMono Nerd Font")

local base_colors = {
	bg = "#181616",
	fg = "#c5c9c5",
}

-- Color theme.
config.colors = {
	-- force_reverse_video_cursor = true,
	foreground = base_colors.fg,
	background = base_colors.bg,

	cursor_bg = "#C8C093",
	cursor_fg = "#C8C093",
	cursor_border = "#C8C093",

	selection_fg = "#C8C093",
	selection_bg = "#2D4F67",

	scrollbar_thumb = "#16161D",
	split = "#16161D",

	ansi = {
		"#0D0C0C",
		"#C4746E",
		"#8A9A7B",
		"#C4B28A",
		"#8BA4B0",
		"#A292A3",
		"#8EA4A2",
		"#C8C093",
	},
	brights = {
		"#A6A69C",
		"#E46876",
		"#87A987",
		"#E6C384",
		"#7FB4CA",
		"#938AA9",
		"#7AA89F",
		"#C5C9C5",
	},
	indexed = { [16] = "#B6927B", [17] = "#B98D7B" },
}

-- Remove extra space.
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Cursor.
config.cursor_thickness = 2

-- Tab bar.
config.window_frame = {
	font = wezterm.font("BerkeleyMono Nerd Font", { weight = "Bold" }),
	font_size = 12,
	active_titlebar_bg = base_colors.bg,
	inactive_titlebar_bg = base_colors.bg,
}

-- Make underlines THICK.
config.underline_position = -6
config.underline_thickness = "250%"

-- Keybindings.
config.disable_default_key_bindings = true
local mods = "ALT|SHIFT"
config.keys = {
	{ mods = mods, key = "x", action = act.ActivateCopyMode },
	{ mods = mods, key = "d", action = act.ShowDebugOverlay },
	{ mods = mods, key = "v", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ mods = mods, key = "s", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ mods = mods, key = "h", action = act.ActivatePaneDirection("Left") },
	{ mods = mods, key = "l", action = act.ActivatePaneDirection("Right") },
	{ mods = mods, key = "k", action = act.ActivatePaneDirection("Up") },
	{ mods = mods, key = "j", action = act.ActivatePaneDirection("Down") },
	{ mods = mods, key = "t", action = act.SpawnTab("CurrentPaneDomain") },
	{ mods = mods, key = "q", action = act.CloseCurrentPane({ confirm = true }) },
	{ mods = mods, key = "y", action = act.CopyTo("Clipboard") },
	{ mods = mods, key = "p", action = act.PasteFrom("Clipboard") },
	{ mods = "ALT", key = "-", action = act.DecreaseFontSize },
	{ mods = "ALT", key = "=", action = act.IncreaseFontSize },
	{ mods = "ALT", key = "0", action = act.ResetFontSize },
	{ mods = "ALT", key = "1", action = act.ActivateTab(0) },
	{ mods = "ALT", key = "2", action = act.ActivateTab(1) },
	{ mods = "ALT", key = "3", action = act.ActivateTab(2) },
	{ mods = "ALT", key = "4", action = act.ActivateTab(3) },
	{ mods = "ALT", key = "5", action = act.ActivateTab(4) },
}

wezterm.on("format-tab-title", function(tab)
	-- Get the process name.
	local process = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

	-- Current working directory.
	local cwd = tab.active_pane.current_working_dir
	cwd = cwd and string.format("%s ", cwd.file_path:gsub(os.getenv("HOME"), "~")) or ""

	-- Format and return the title.
	return string.format("(%d %s) %s", tab.tab_index + 1, process, cwd)
end)

return config
