local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"

config.font_size = 11.5
config.font = wezterm.font("JetBrainsMonoNerdFont", { weight = "Medium" })
config.max_fps = 120
config.disable_default_key_bindings = true
config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.5 }
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.cursor_thickness = 2
config.hide_tab_bar_if_only_one_tab = true

local function pane_navigation_action(direction, fallback_direction)
	return wezterm.action_callback(function(win, pane)
		local num_panes = #win:active_tab():panes()
		local pane_direction = num_panes == 2 and fallback_direction or direction
		win:perform_action({ ActivatePaneDirection = pane_direction }, pane)
	end)
end

config.keys = {
	{ mods = "ALT|SHIFT", key = "x", action = act.ActivateCopyMode },
	{ mods = "CTRL|SHIFT", key = "c", action = act.CopyTo("Clipboard") },
	{ mods = "CTRL|SHIFT", key = "v", action = act.PasteFrom("Clipboard") },

	{ mods = "ALT|SHIFT", key = "d", action = act.ShowDebugOverlay },

	{ mods = "ALT|SHIFT", key = "v", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ mods = "ALT|SHIFT", key = "s", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ mods = "ALT|SHIFT", key = "h", action = pane_navigation_action("Left", "Prev") },
	{ mods = "ALT|SHIFT", key = "l", action = pane_navigation_action("Right", "Next") },
	{ mods = "ALT|SHIFT", key = "k", action = pane_navigation_action("Up", "Prev") },
	{ mods = "ALT|SHIFT", key = "j", action = pane_navigation_action("Down", "Next") },

	{ mods = "ALT|SHIFT", key = "t", action = act.SpawnTab("CurrentPaneDomain") },
	{ mods = "ALT|SHIFT", key = "c", action = act.CloseCurrentPane({ confirm = false }) },

	{ mods = "ALT", key = "-", action = act.DecreaseFontSize },
	{ mods = "ALT", key = "=", action = act.IncreaseFontSize },
	{ mods = "CTRL", key = "0", action = act.ResetFontSize },

	{
		key = "r",
		mods = "ALT|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line and line ~= "" then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	{ mods = "ALT", key = "1", action = act.ActivateTab(0) },
	{ mods = "ALT", key = "2", action = act.ActivateTab(1) },
	{ mods = "ALT", key = "3", action = act.ActivateTab(2) },
	{ mods = "ALT", key = "4", action = act.ActivateTab(3) },
	{ mods = "ALT", key = "5", action = act.ActivateTab(4) },
	{ mods = "ALT", key = "6", action = act.ActivateTab(5) },
	{ mods = "ALT", key = "7", action = act.ActivateTab(6) },
	{ mods = "ALT", key = "8", action = act.ActivateTab(7) },
	{ mods = "ALT", key = "9", action = act.ActivateTab(8) },
	{ mods = "ALT", key = "0", action = act.ActivateTab(9) },

	{ mods = "ALT|SHIFT", key = "!", action = wezterm.action.MoveTab(0) },
	{ mods = "ALT|SHIFT", key = "@", action = wezterm.action.MoveTab(1) },
	{ mods = "ALT|SHIFT", key = "#", action = wezterm.action.MoveTab(2) },
	{ mods = "ALT|SHIFT", key = "$", action = wezterm.action.MoveTab(3) },
	{ mods = "ALT|SHIFT", key = "%", action = wezterm.action.MoveTab(4) },
	{ mods = "ALT|SHIFT", key = "^", action = wezterm.action.MoveTab(5) },
	{ mods = "ALT|SHIFT", key = "&", action = wezterm.action.MoveTab(6) },
	{ mods = "ALT|SHIFT", key = "*", action = wezterm.action.MoveTab(7) },
	{ mods = "ALT|SHIFT", key = "(", action = wezterm.action.MoveTab(8) },
	{ mods = "ALT|SHIFT", key = ")", action = wezterm.action.MoveTab(9) },

	{ mods = "ALT|SHIFT", key = "{", action = act.MoveTabRelative(-1) },
	{ mods = "ALT|SHIFT", key = "}", action = act.MoveTabRelative(1) },
}

config.color_scheme = "Default Dark (base16)"
-- config.color_scheme = "Default Light (base16)"

return config
