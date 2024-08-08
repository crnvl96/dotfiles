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

now(require('config.opts'))
now(require('config.autocmds'))
now(require('config.keymaps'))

now(require('plugins.colorscheme'))
now(require('plugins.requirerements'))

now(require('plugins.lang'))
now(require('plugins.lsp'))
now(require('plugins.fzf'))
now(require('plugins.dap'))

later(require('plugins.conform'))
later(require('plugins.oil'))
later(require('plugins.grug-far'))
later(require('plugins.fugitive'))
later(require('plugins.quickfix'))

later(require('plugins.treesitter'))
later(require('plugins.clue'))
