require("full-border"):setup()

if os.getenv("NVIM") then
	require("toggle-pane"):entry("min-preview")
end
