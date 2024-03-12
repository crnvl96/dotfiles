local choose_item_under_cursor = function()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	vim.cmd("keepjumps cc " .. current_line)
	vim.cmd("wincmd j")
end

vim.keymap.set("n", "<CR>", choose_item_under_cursor, { buffer = vim.api.nvim_get_current_buf() })
vim.cmd("packadd cfilter")
