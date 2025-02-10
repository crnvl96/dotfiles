local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

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

require('mini.deps').setup()

Add, Now, Later = MiniDeps.add, MiniDeps.now, MiniDeps.later

Add({ name = 'mini.nvim' })

require('config.utils')

require('plugins.snacks')

require('config.opts')
require('config.keymaps')
require('config.autocmds')

require('plugins.colorscheme')

require('plugins.plenary')
require('plugins.fugitive')
require('plugins.treesitter')

require('plugins.mini')

require('plugins.blink')
require('plugins.lspconfig')

require('plugins.conform')
require('plugins.grug_far')
require('plugins.codecompanion')
require('plugins.whichkey')
require('plugins.neogen')
