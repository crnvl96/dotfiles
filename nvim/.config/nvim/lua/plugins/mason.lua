local add = MiniDeps.add
local tools = require('tools')
local ensure_installed = {}

return function()
    add({
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

    require('mini.misc').setup_restore_cursor({ center = true })

    require('mini.misc').setup_termbg_sync()

    require('mason').setup()

    vim.list_extend(ensure_installed, vim.tbl_keys(tools.servers))
    vim.list_extend(ensure_installed, tools.formatters)
    vim.list_extend(ensure_installed, tools.debuggers)

    require('mason-tool-installer').setup({
        ensure_installed = ensure_installed,
        delay = 1000,
    })
end
