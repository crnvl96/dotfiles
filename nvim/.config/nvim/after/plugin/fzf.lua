local ok = pcall(require, "fzf-lua")
if ok then
	vim.api.nvim_create_autocmd("VimResized", {
		group = vim.api.nvim_create_augroup(vim.g.whoami .. "/fzf-lua", { clear = true }),
		pattern = "*",
		command = 'lua require("fzf-lua").redraw()',
	})

	require("fzf-lua").register_ui_select(function(_, items)
		local min_h, max_h = 0.15, 0.70
		local h = (#items + 4) / vim.o.lines
		if h < min_h then
			h = min_h
		elseif h > max_h then
			h = max_h
		end
		return { winopts = { height = h, width = 0.60, row = 0.40 } }
	end)

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

	vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "files" })
	vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<CR>", { desc = "marks" })
	vim.keymap.set("n", "<leader>fg", "<cmd>lua require('fzf-lua').grep({ search='' })<CR>", { desc = "grep" })
	vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "buffers" })
	vim.keymap.set("n", "<leader>fl", "<cmd>FzfLua lines<CR>", { desc = "lines" })
	vim.keymap.set("n", "<leader>fm", "<cmd>FzfLua marks<CR>", { desc = "lines" })
	vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua resume<CR>", { desc = "resume" })

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup(vim.g.whoami .. "/ft-qf", { clear = true }),
		pattern = { "qf" },
		callback = function()
			local choose_item_under_cursor = function()
				local current_line = vim.api.nvim_win_get_cursor(0)[1]
				vim.cmd("keepjumps cc " .. current_line)
				vim.cmd("wincmd j")
			end

			local open_with_fzf = function()
				vim.cmd("ccl")
				require("fzf-lua").quickfix()
			end

			vim.keymap.set("n", "<CR>", choose_item_under_cursor, { buffer = vim.api.nvim_get_current_buf() })
			vim.keymap.set("n", ".", open_with_fzf, { buffer = vim.api.nvim_get_current_buf() })
			vim.cmd("packadd cfilter")
		end,
	})
end
