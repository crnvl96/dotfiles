local vim_stdpath = vim.fn.stdpath('data')
local mini_path = vim_stdpath .. '/site/pack/deps/start/mini.nvim'

local clone_cmd = {
  'git',
  'clone',
  '--filter=blob:none',
  'https://github.com/echasnovski/mini.nvim',
  mini_path,
}

if not vim.loop.fs_stat(mini_path) then
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()

MiniDeps.add({
  name = 'mini.nvim',
  checkout = 'v0.16.0',
  monitor = 'main',
})

local notify = require('mini.notify')
notify.setup()
vim.notify = notify.make_notify()

require('mini.doc').setup()
require('mini.icons').setup()
require('mini.misc').setup()

vim.ui.select = require('mini.pick').ui_select
