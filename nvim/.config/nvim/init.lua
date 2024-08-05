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

local now = deps.now
local later = deps.later

now(function() require('config.opts') end)
now(function() require('config.autocmds') end)
now(function() require('config.keymaps') end)

now(function() require('lspattach') end)

now(function() require('plugins.colorscheme') end)
now(function() require('plugins.misc') end)

now(function() require('plugins.mason') end)
now(function() require('plugins.mason-tool-installer') end)
now(function() require('plugins.cmp') end)
now(function() require('plugins.lsp') end)
now(function() require('plugins.dap') end)

later(function() require('plugins.conform') end)
later(function() require('plugins.fzf') end)
later(function() require('plugins.oil') end)
later(function() require('plugins.fugitive') end)
later(function() require('plugins.treesitter') end)

later(function() require('plugins.clue') end)

later(function()
  for _, lhs in ipairs({ '[%', ']%', 'g%' }) do
    vim.keymap.del('n', lhs)
  end
end)

later(function() require('mini.align').setup() end)
