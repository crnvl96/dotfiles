local function apply_visual_macro()
	return ":norm @" .. vim.fn.getcharstr() .. "<CR>"
end

local function split_into_tmux_pane()
	return vim.fn.system('tmux split-window -h -c "' .. vim.fn.expand("%:p:h") .. '"')
end

local function delmarks()
	vim.cmd([[delm!]])
	vim.cmd([[delm A-Z]])
	vim.cmd([[delm a-z]])
	vim.cmd([[delm 0-9]])
end

local function render_last_messages()
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
end

vim.keymap.set("", "<BS>", "<Leader>", { silent = true })
vim.keymap.set("", "<CR>", "<Nop>", { silent = true })
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })
vim.keymap.set("", "<C-f>", "<Leader>", { silent = true })
vim.keymap.set("", "<C-b>", "", { silent = true })

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

vim.keymap.set("n", "gp", "`[v`]", { silent = true, noremap = true, desc = "select the last pasted text" })
vim.keymap.set("n", "go", "`]", { silent = true, noremap = true, desc = "go to end of last pasted text" })
vim.keymap.set("n", "gO", "`[", { silent = true, noremap = true, desc = "go to start of last pasted text" })

vim.keymap.set("n", "<Leader>cf", "let @+ = expand('%:p')", { silent = true, expr = true, desc = "copy filename" })
vim.keymap.set("c", "%%", "getcmdtype() == ':' ? expand('%:h') .. '/' : '%%'", { expr = true })
vim.keymap.set("x", "@", apply_visual_macro, { silent = true, expr = true })
vim.keymap.set("n", "<leader>T", split_into_tmux_pane, { silent = true, expr = true, desc = "split tmux pane" })
vim.keymap.set("n", "<leader>M", render_last_messages, { silent = true, desc = "print last messages" })
vim.keymap.set("n", "<leader>mx", delmarks, { silent = true, desc = "delmarks" })

vim.keymap.set("n", "<leader>bx", "<cmd>%bd|e#|bd#<CR>", { silent = true, desc = "delete all other buffers" })

vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "last window", remap = true })
vim.keymap.set("n", "<leader>wx", "<cmd>only<CR>", { desc = "close other windows" })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "delete window", remap = true })
vim.keymap.set("n", "<leader>wv", "<C-W>v", { desc = "split window below", remap = true })
vim.keymap.set("n", "<leader>wh", "<C-W>h", { desc = "split window right", remap = true })

vim.cmd([[
	xnoremap <C-_> <Esc>/\%V
]])
