MiniDeps.add('williamboman/mason-lspconfig.nvim')
MiniDeps.add('neovim/nvim-lspconfig')

local capabilities = function()
    return vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
    )
end

local servers = {
    vtsls = {},
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        '${3rd}/luv/library',
                        '${3rd}/busted/library',
                    },
                },
            },
        },
    },
    eslint = {
        settings = {
            format = false,
        },
    },
    gopls = {
        settings = {
            gopls = {
                gofumpt = true,
                buildFlags = { '-tags=debug' },
                experimentalPostfixCompletions = true,
                usePlaceholders = false,
                staticcheck = true,
                completeUnimported = true,
            },
        },
    },
}

local on_attach = function(client, buf)
    client.server_capabilities.documentFormattingProvider = false

    vim.bo[buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    vim.keymap.set('n', 'grr', vim.lsp.buf.references, { desc = 'vim.lsp.buf.references()', buffer = buf })
    vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = 'vim.lsp.buf.definition()', buffer = buf })
    vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, { desc = 'vim.lsp.buf.implementation()', buffer = buf })
    vim.keymap.set('n', 'gry', vim.lsp.buf.type_definition, { desc = 'vim.lsp.buf.typedefs()', buffer = buf })
    vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, { desc = 'vim.lsp.buf.code_action()', buffer = buf })
    vim.keymap.set('n', 'grs', vim.lsp.buf.document_symbol, { desc = 'vim.lsp.buf.document_symbol()', buffer = buf })
    vim.keymap.set('n', 'grx', vim.diagnostic.setqflist, { desc = 'vim.diagnistic.setqflist()', buffer = buf })
    vim.keymap.set('n', 'grS', vim.lsp.buf.workspace_symbol, { desc = 'vim.lsp.buf.workspace_symbol()', buffer = buf })
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'vim.lsp.buf.signature_help()', buffer = buf })

    vim.keymap.set('n', '<leader>rr', vim.lsp.buf.references, { desc = 'vim.lsp.buf.references()', buffer = buf })
    vim.keymap.set('n', '<leader>rd', vim.lsp.buf.definition, { desc = 'vim.lsp.buf.definition()', buffer = buf })
    vim.keymap.set('n', '<leader>ri', vim.lsp.buf.implementation, { desc = 'vim.lsp.buf.implementation()', buffer = buf })
    vim.keymap.set('n', '<leader>ry', vim.lsp.buf.type_definition, { desc = 'vim.lsp.buf.typedefs()', buffer = buf })
    vim.keymap.set('n', '<leader>ra', vim.lsp.buf.code_action, { desc = 'vim.lsp.buf.code_action()', buffer = buf })
    vim.keymap.set(
        'n',
        '<leader>rs',
        vim.lsp.buf.document_symbol,
        { desc = 'vim.lsp.buf.document_symbol()', buffer = buf }
    )
    vim.keymap.set('n', '<leader>rx', vim.diagnostic.setqflist, { desc = 'vim.diagnistic.setqflist()', buffer = buf })
    vim.keymap.set(
        'n',
        '<leader>rS',
        vim.lsp.buf.workspace_symbol,
        { desc = 'vim.lsp.buf.workspace_symbol()', buffer = buf }
    )
end

local bootstrap = function(callback)
    local methods = vim.lsp.protocol.Methods
    local register_capability = vim.lsp.handlers[methods.client_registerCapability]

    vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then return end
        callback(client, vim.api.nvim_get_current_buf())
        return register_capability(err, res, ctx)
    end

    vim.diagnostic.config({
        title = false,
        underline = true,
        virtual_text = true,
        signs = false,
        update_in_insert = false,
        severity_sort = true,
        float = {
            source = 'if_many',
            style = 'minimal',
            border = 'rounded',
            header = '',
            prefix = '',
        },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(e)
            local client = vim.lsp.get_client_by_id(e.data.client_id)
            if not client then return end
            callback(client, e.buf)
        end,
    })
end

bootstrap(on_attach)

local mlsp = require('mason-lspconfig')
local lsp = require('lspconfig')

mlsp.setup({
    handlers = {
        function(server_name)
            local server = servers[server_name] or {}

            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities(), server.capabilities or {})

            lsp[server_name].setup(server)
        end,
    },
})
