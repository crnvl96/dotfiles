return function()
    local tools = require('tools')
    local ensure_installed = {}
    local f = require('functions')
    local map = f.map()

    MiniDeps.add({
        source = 'WhoIsSethDaniel/mason-tool-installer.nvim',
        depends = {
            { source = 'williamboman/mason-lspconfig.nvim' },
            { source = 'jay-babu/mason-nvim-dap.nvim' },
            {
                source = 'williamboman/mason.nvim',
                hooks = {
                    post_checkout = function() vim.cmd('MasonUpdate') end,
                },
            },
        },
    })

    require('mini.icons').setup()
    require('mini.icons').mock_nvim_web_devicons()

    require('mini.misc').setup_restore_cursor({ center = true })
    require('mini.misc').setup_termbg_sync()

    require('mini.bufremove').setup()
    map.ln('bd', function() require('mini.bufremove').delete(0, false) end, 'delete buffer')

    require('mason').setup()

    vim.list_extend(ensure_installed, vim.tbl_keys(tools.servers))
    vim.list_extend(ensure_installed, tools.formatters)
    vim.list_extend(ensure_installed, tools.debuggers)

    require('mason-tool-installer').setup({
        ensure_installed = ensure_installed,
        delay = 1000,
    })
end
