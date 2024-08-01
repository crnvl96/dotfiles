local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

local deps = require('mini.deps')
deps.setup({ path = { package = path_package } })

local now, ltr = deps.now, deps.later

now(function() require('plugins.mini-misc') end)
now(function() require('config.opts') end)
now(function() require('config.autocmds') end)
now(function() require('config.keymaps') end)

vim.cmd('colorscheme minicyan')

now(function() require('plugins.mini-icons') end)
now(function() require('plugins.lsp') end)
ltr(function() require('plugins.grug-far') end)
ltr(function() require('plugins.mini-completion') end)
ltr(function() require('plugins.conform') end)
ltr(function() require('plugins.mini-pick') end)
