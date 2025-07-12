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

require('mini.deps').setup({
  path = {
    snapshot = NVIM_DIR .. '/mini-deps-snap',
  },
})

local HOME = os.getenv('HOME')
local node_version_cmd = "mise ls --cd ~ | grep '^node' | head -n 1 | awk '{print $2}'"
local node_version = vim.fn.system(node_version_cmd):gsub('\n', '')

if node_version == '' then
  vim.notify(
    'Could not determine Node.js version from mise. Please ensure mise is installed and a Node.js version is set.',
    vim.log.levels.WARN
  )
else
  local default_nodejs = HOME .. '/.local/share/mise/installs/node/' .. node_version .. '/bin/'
  vim.g.node_host_prog = default_nodejs .. 'node'
  vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH
end

dofile(NVIM_DIR .. '/settings/theme.lua')
dofile(NVIM_DIR .. '/settings/lsp.lua')
dofile(NVIM_DIR .. '/settings/opts.lua')
dofile(NVIM_DIR .. '/settings/keymaps.lua')
dofile(NVIM_DIR .. '/settings/autocmds.lua')
dofile(NVIM_DIR .. '/settings/onattach.lua')
dofile(NVIM_DIR .. '/settings/plugins.lua')
