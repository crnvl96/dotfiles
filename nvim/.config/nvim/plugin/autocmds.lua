vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup(vim.g.whoami .. "/colorscheme", { clear = true }),
	callback = function()
		vim.api.nvim_set_hl(0, "StatusLine", { link = "Normal" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })
		vim.api.nvim_set_hl(0, "PMenuSbar", { link = "Normal" })
		vim.api.nvim_set_hl(0, "PMenu", { link = "Normal" })
		vim.api.nvim_set_hl(0, "PMenuSel", { bg = "#484848" })
		vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
		vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "Normal" })
		vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })

		local signs = { Error = "●", Warn = "●", Hint = "●", Info = "●" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup(vim.g.whoami .. "/ft-qf", { clear = true }),
	pattern = { "qf" },
	callback = function()
		local choose_item_under_cursor = function()
			local current_line = vim.api.nvim_win_get_cursor(0)[1]
			vim.cmd("keepjumps cc " .. current_line)
			vim.cmd("wincmd j")
		end

		vim.keymap.set("n", "<CR>", choose_item_under_cursor, { buffer = vim.api.nvim_get_current_buf() })
		vim.cmd("packadd cfilter")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup(vim.g.whoami .. "/ft-md", { clear = true }),
	pattern = { "markdown", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup(vim.g.whoami .. "/ft-json", { clear = true }),
	pattern = { "json" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup(vim.g.whoami .. "/checktime", { clear = true }),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup(vim.g.whoami .. "/highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = vim.api.nvim_create_augroup(vim.g.whoami .. "/resize-vim", { clear = true }),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup(vim.g.whoami .. "/last-loc", { clear = true }),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup(vim.g.whoami .. "/qf", { clear = true }),
	callback = function()
		local fn = vim.fn
		function _G.qftf(info)
			local items
			local ret = {}
			if info.quickfix == 1 then
				items = fn.getqflist({ id = info.id, items = 0 }).items
			else
				items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
			end
			local limit = 99
			local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
			local validFmt = "%s │%5d:%-3d│%s %s"
			for i = info.start_idx, info.end_idx do
				local e = items[i]
				local fname = ""
				local str
				if e.valid == 1 then
					if e.bufnr > 0 then
						fname = fn.bufname(e.bufnr)
						if fname == "" then
							fname = "[No Name]"
						else
							fname = fname:gsub("^" .. vim.env.HOME, "~")
						end
						-- char in fname may occur more than 1 width, ignore this issue in order to keep performance
						if #fname <= limit then
							fname = fnameFmt1:format(fname)
						else
							fname = fnameFmt2:format(fname:sub(1 - limit))
						end
					end
					local lnum = e.lnum > 99999 and -1 or e.lnum
					local col = e.col > 999 and -1 or e.col
					local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
					str = validFmt:format(fname, lnum, col, qtype, e.text)
				else
					str = e.text
				end
				table.insert(ret, str)
			end
			return ret
		end
		vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
	end,
})
