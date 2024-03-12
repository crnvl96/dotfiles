vim.keymap.set("", "<BS>", "<Leader>", { silent = true })
vim.keymap.set("", "<CR>", "<Nop>", { silent = true })
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })

vim.keymap.set("n", "Y", "y$", { silent = true })
vim.keymap.set("x", "p", '"_dp', { silent = true })
vim.keymap.set("x", "P", '"_dP', { silent = true })
vim.keymap.set("x", "<", "<gv", { silent = true })
vim.keymap.set("x", ">", ">gv", { silent = true })
vim.keymap.set("n", "n", "nzzzv", { silent = true })
vim.keymap.set("n", "N", "Nzzzv", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true })
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { silent = true })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -10<CR>", { silent = true })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +10<CR>", { silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { silent = true, expr = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { silent = true, expr = true })
vim.keymap.set({ "n", "i" }, "<Esc>", "<cmd>noh<CR><Esc>", { silent = true })
vim.keymap.set("x", "@", function()
	return ":norm @" .. vim.fn.getcharstr() .. "<CR>"
end, { silent = true, expr = true })

vim.keymap.set("n", "gp", "`[v`]", { silent = true, noremap = true, desc = "select the last pasted text" })
vim.keymap.set("n", "go", "`]", { silent = true, noremap = true, desc = "go to end of last pasted text" })
vim.keymap.set("n", "gO", "`[", { silent = true, noremap = true, desc = "go to start of last pasted text" })
vim.keymap.set("n", "<Leader>cf", "let @+ = expand('%:p')", { silent = true, expr = true, desc = "copy filename" })
vim.cmd([[
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h') .. '/' : '%%'
]])
vim.keymap.set("n", "<leader>T", function()
	return vim.fn.system('tmux split-window -h -c "' .. vim.fn.expand("%:p:h") .. '"')
end, { silent = true, expr = true, desc = "split tmux pane" })
vim.keymap.set("n", "<leader>M", function()
	vim.cmd("bel 10new")
	local buf = vim.api.nvim_get_current_buf()
	for name, value in pairs({
		filetype = "scratch",
		buftype = "nofile",
		bufhidden = "hide",
		swapfile = false,
		modifiable = true,
	}) do
		vim.api.nvim_set_option_value(name, value, { buf = buf })
	end
	vim.api.nvim_buf_call(buf, function()
		vim.cmd([[put=execute('messages')]])
	end)
end, { silent = true, desc = "print last messages" })
