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

require('mini.deps').setup({ path = { package = path_package } })

MiniDeps.now(function()
  local icons = require('mini.icons')
  icons.setup()
  icons.mock_nvim_web_devicons()
end)

MiniDeps.now(function()
  local misc = require('mini.misc')
  misc.setup_auto_root()
  misc.setup_restore_cursor({ center = true })
  misc.setup_termbg_sync()
end)

MiniDeps.now(function() require('config.opts') end)
MiniDeps.now(function() require('config.autocmds') end)
MiniDeps.now(function() require('config.keymaps') end)

MiniDeps.now(function() require('colorscheme') end)
MiniDeps.now(function() require('compe') end)
MiniDeps.now(function() require('lspattach') end)
MiniDeps.now(function() require('lsp') end)
MiniDeps.now(function() require('fmt') end)
MiniDeps.now(function() require('picker') end)
MiniDeps.now(function() require('ex') end)
MiniDeps.now(function() require('git') end)
MiniDeps.now(function() require('ts') end)
