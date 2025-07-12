_G.HOME = os.getenv('HOME')
_G.NVIM_DIR = HOME .. '/.config/nvim'
_G.MINI_PATH = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(MINI_PATH) then
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    MINI_PATH,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { snapshot = NVIM_DIR .. '/mini-deps-snap' } })
require('mini.icons').setup()

dofile(NVIM_DIR .. '/settings/path.lua')
dofile(NVIM_DIR .. '/settings/theme.lua')
dofile(NVIM_DIR .. '/settings/lsp.lua')
dofile(NVIM_DIR .. '/settings/opts.lua')
dofile(NVIM_DIR .. '/settings/keymaps.lua')
dofile(NVIM_DIR .. '/settings/autocmds.lua')
dofile(NVIM_DIR .. '/settings/onattach.lua')

MiniDeps.now(function()
  MiniDeps.add({ name = 'mini.nvim' })
  MiniDeps.add('nvim-lua/plenary.nvim')
  MiniDeps.add('neovim/nvim-lspconfig')
  MiniDeps.add('tpope/vim-fugitive')
  MiniDeps.add('tpope/vim-rhubarb')
  MiniDeps.add('tpope/vim-sleuth')
  MiniDeps.add('mbbill/undotree')
end)

dofile(NVIM_DIR .. '/plugins/mason.lua')
dofile(NVIM_DIR .. '/plugins/treesitter.lua')
dofile(NVIM_DIR .. '/plugins/grug-far.lua')
dofile(NVIM_DIR .. '/plugins/conform.lua')
dofile(NVIM_DIR .. '/plugins/nvim-lint.lua')
dofile(NVIM_DIR .. '/plugins/nvim-dap.lua')
dofile(NVIM_DIR .. '/plugins/blink.lua')
dofile(NVIM_DIR .. '/plugins/codecompanion.lua')
dofile(NVIM_DIR .. '/plugins/fzf.lua')
dofile(NVIM_DIR .. '/plugins/minifiles.lua')

-- MiniDeps.later(function()
-- 	vim.cmd("set rtp+=~/Developer/personal/lazydocker.nvim/")
-- 	require("lazydocker").setup({
-- 		window = {
-- 			settings = {
-- 				width = 0.9,
-- 				height = 0.9,
-- 			},
-- 		},
-- 	})
-- 	vim.keymap.set({ "n", "t" }, "<leader>zz", "<Cmd>lua LazyDocker.toggle()<CR>")
-- 	vim.keymap.set({ "n", "t" }, "<leader>zp", "<Cmd>lua LazyDocker.toggle({engine='podman'})<CR>")
-- end)
