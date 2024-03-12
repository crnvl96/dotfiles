local ok

ok = pcall(require, "mini.comment")
if ok then
	require("mini.comment").setup()
end

ok = pcall(require, "mini.splitjoin")
if ok then
	require("mini.splitjoin").setup()
end

ok = pcall(require, "mini.clue")
if ok then
	for _, lhs in ipairs({ "[%", "]%", "g%" }) do
		vim.keymap.del("n", lhs)
	end

	local function mark_clues()
		local marks = {}
		vim.list_extend(marks, vim.fn.getmarklist(vim.api.nvim_get_current_buf()))
		vim.list_extend(marks, vim.fn.getmarklist())

		---@diagnostic disable-next-line: undefined-field
		return vim.iter.map(function(mark)
			local key = mark.mark:sub(2, 2)

			if not string.match(key, "^%a") then
				return nil
			end

			local desc
			if mark.file then
				desc = vim.fn.fnamemodify(mark.file, ":p:~:.")
			elseif mark.pos[1] and mark.pos[1] ~= 0 then
				local line_num = mark.pos[2]
				local lines = vim.fn.getbufline(mark.pos[1], line_num)
				if lines and lines[1] then
					desc = string.format("%d: %s", line_num, lines[1]:gsub("^%s*", ""))
				end
			end

			if desc then
				return {
					{ mode = "n", keys = string.format("`%s", key), desc = desc },
					{ mode = "n", keys = string.format("'%s", key), desc = desc },
				}
			end
		end, marks)
	end

	local miniclue = require("mini.clue")
	miniclue.setup({
		triggers = {
			{ mode = "n", keys = "<Leader>" },
			{ mode = "x", keys = "<Leader>" },
			{ mode = "i", keys = "<C-x>" },
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },
			{ mode = "n", keys = "<C-w>" },
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
			{ mode = "n", keys = "[" },
			{ mode = "n", keys = "]" },
			{ mode = "n", keys = "y" },
			{ mode = "n", keys = "c" },
			{ mode = "n", keys = "d" },
		},
		clues = {
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.windows(),
			miniclue.gen_clues.z(),
			mark_clues,
			{ mode = "n", keys = "<leader>b", desc = "+buffers" },
			{ mode = "n", keys = "<leader>g", desc = "+git" },
			{ mode = "n", keys = "<leader>m", desc = "+marks" },
			{ mode = "n", keys = "<leader>q", desc = "+quit" },
			{ mode = "n", keys = "<leader>f", desc = "+find" },
			{ mode = "n", keys = "<leader>c", desc = "+code" },
			{ mode = "x", keys = "<leader>c", desc = "+code" },
			{ mode = "n", keys = "<leader>h", desc = "+hunks" },
			{ mode = "x", keys = "<leader>h", desc = "+hunks" },
			{ mode = "n", keys = "<leader>w", desc = "+windows" },
			{ mode = "x", keys = "<leader>w", desc = "+windows" },

			{ mode = "n", keys = "gz", desc = "+surround" },
			{ mode = "x", keys = "gz", desc = "+surround" },
			{ mode = "n", keys = "ys", desc = "+surround" },
			{ mode = "n", keys = "ds", desc = "+surround" },
			{ mode = "n", keys = "cs", desc = "+surround" },
			{ mode = "n", keys = "g'", desc = "+marks" },
			{ mode = "x", keys = "g`", desc = "+marks" },
		},
		window = {
			config = {
				width = "auto",
			},
			delay = 200,
			scroll_down = "<C-f>",
			scroll_up = "<C-b>",
		},
	})
end
