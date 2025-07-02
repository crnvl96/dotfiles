_G.HOME = os.getenv("HOME")
_G.NVIM_DIR = HOME .. "/.local/share/dotfiles/default/nvim"
_G.MINI_PATH = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"

if not vim.loop.fs_stat(MINI_PATH) then
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		MINI_PATH,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("mini.deps").setup({
	path = {
		snapshot = NVIM_DIR .. "/mini-deps-snap",
	},
})

dofile(NVIM_DIR .. "/theme.lua")
dofile(NVIM_DIR .. "/lsp.lua")
dofile(NVIM_DIR .. "/settings.lua")
dofile(NVIM_DIR .. "/keymaps.lua")
dofile(NVIM_DIR .. "/autocmds.lua")
dofile(NVIM_DIR .. "/onattach.lua")
dofile(NVIM_DIR .. "/plugins.lua")
