-- Place where the package manager will be installed
local path_package = vim.fn.stdpath('data') .. '/site/'
-- Place where the mini framework will be installed
local mini_path = path_package .. 'pack/deps/start/mini.nvim'

-- If the package manager is not present on the system, install is now
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

-- Setup the package manager
local deps = require('mini.deps')
deps.setup({ path = { package = path_package } })

-- Package manager aliases
local add = MiniDeps.add
local now = deps.now
local later = deps.later

now(function() require('config.opts') end)
now(function() require('config.autocmds') end)
now(function() require('config.keymaps') end)

now(function()
    add('0xstepit/flow.nvim')
    add('Aliqyan-21/darkvoid.nvim')

    require('flow').setup({
        transparent = true,
        fluo_color = 'pink',
        mode = 'normal',
        aggressive_spell = false,
    })

    require('darkvoid').setup({
        transparent = true,
        glow = true,
    })

    -- vim.cmd('colorscheme flow')
    vim.cmd('colorscheme darkvoid')
end)

now(function()
    add({
        source = 'williamboman/mason.nvim',
        hooks = {
            post_checkout = function() vim.cmd('MasonUpdate') end,
        },
    })

    add({
        source = 'WhoIsSethDaniel/mason-tool-installer.nvim',
        depends = {
            { source = 'williamboman/mason.nvim' },
            { source = 'williamboman/mason-lspconfig.nvim' },
            { source = 'jay-babu/mason-nvim-dap.nvim' },
        },
    })

    local misc = require('mini.misc')
    local tools = require('tools')
    local mason = require('mason')
    local masontoolinstaller = require('mason-tool-installer')

    local servers = vim.tbl_keys(tools.servers)
    local formatters = tools.formatters
    local debuggers = tools.debuggers

    local ensure_installed = {}

    vim.list_extend(ensure_installed, servers)
    vim.list_extend(ensure_installed, formatters)
    vim.list_extend(ensure_installed, debuggers)

    misc.setup_restore_cursor({ center = true })
    misc.setup_termbg_sync()

    mason.setup()
    masontoolinstaller.setup({ ensure_installed = ensure_installed, delay = 1000 })
end)

now(function()
    add('Olical/conjure')
    add('tpope/vim-dispatch')
    add('clojure-vim/vim-jack-in')
    add('radenling/vim-dispatch-neovim')
end)

now(function() require('plugins.cmp') end)
now(function() require('plugins.lsp') end)
now(function() require('plugins.dap') end)

later(function() require('plugins.conform') end)
later(function() require('plugins.fzf') end)
later(function() require('plugins.oil') end)
later(function() require('plugins.grug-far') end)
later(function() require('plugins.fugitive') end)

later(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        hooks = { post_update = function() vim.cmd('TSUpdate') end },
    })

    add({
        source = 'maxandron/goplements.nvim',
    })

    local treesitter = require('nvim-treesitter.configs')
    local goplements = require('goplements')
    local tools = require('tools')

    goplements.setup({ display_package = true })

    treesitter.setup({
        ensure_installed = tools.ts_parsers,
        sync_install = false,
        auto_install = true,
        indent = { enable = true },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { 'markdown' },
        },
    })
end)

later(function() require('plugins.clue') end)

later(function()
    for _, lhs in ipairs({ '[%', ']%', 'g%' }) do
        vim.keymap.del('n', lhs)
    end
end)
