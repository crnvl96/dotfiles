local ok = pcall(require, "fzf-lua")
if ok then
	vim.api.nvim_create_autocmd("VimResized", {
		group = vim.api.nvim_create_augroup(vim.g.whoami .. "/fzf-lua", { clear = true }),
		pattern = "*",
		command = 'lua require("fzf-lua").redraw()',
	})

	require("fzf-lua").setup({
		file_ignore_patterns = { "%.svg$" },
		keymap = {
			builtin = {
				["<m-p>"] = "toggle-preview",
			},
			fzf = {
				["alt-p"] = "toggle-preview",
				["ctrl-o"] = "toggle-all",
				["ctrl-w"] = "unix-line-discard",
				["ctrl-z"] = "abort",
				["ctrl-f"] = "half-page-down",
				["ctrl-b"] = "half-page-up",
				["ctrl-a"] = "beginning-of-line",
				["ctrl-e"] = "end-of-line",
			},
		},
		winopts_fn = function()
			local split = "botright new"
			local height = math.floor(vim.o.lines * 0.8)
			return {
				split = split .. " | resize " .. tostring(height),
				preview = {
					hidden = "nohidden",
					vertical = "up:50%",
					horizontal = "right:40%",
					layout = "vertical",
					flip_columns = 120,
				},
			}
		end,
	})
end
