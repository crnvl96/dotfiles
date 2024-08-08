return function()
    MiniDeps.add({
        source = 'hrsh7th/nvim-cmp',
        depends = {
            { source = 'hrsh7th/cmp-nvim-lsp' },
            { source = 'hrsh7th/cmp-buffer' },
            { source = 'hrsh7th/cmp-path' },
            { source = 'hrsh7th/cmp-nvim-lua' },
            -- { source = 'PaterJason/cmp-conjure' },
        },
    })

    MiniDeps.add({
        source = 'neovim/nvim-lspconfig',
        depends = {
            { source = 'williamboman/mason-lspconfig.nvim' },
            { source = 'williamboman/mason.nvim' },
            { source = 'hrsh7th/cmp-nvim-lsp' },
            { source = 'WhoIsSethDaniel/mason-tool-installer.nvim' },
        },
    })

    local cmp = require('cmp')
    local cmp_defaults = require('cmp.config.default')()
    local cmp_types = require('cmp.types')

    cmp.setup({
        snippet = {
            expand = function(args) vim.snippet.expand(args.body) end,
        },
        sorting = cmp_defaults.sorting,
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping({
                i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                        fallback()
                    end
                end,
            }),
        }),
        sources = cmp.config.sources({
            {
                name = 'nvim_lsp',
                entry_filter = function(entry)
                    local kind = entry:get_kind()
                    local type = cmp_types.lsp.CompletionItemKind[kind]

                    return type ~= 'Text' and type ~= 'Snippet'
                end,
            },
            { name = 'nvim_lua' },
            -- { name = 'conjure' },
            { name = 'path' },
        }, {
            { name = 'buffer' },
        }),
    })

    local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
    )

    local function on_attach(client, bufnr)
        local function set(lhs, rhs, desc, mode)
            local s = vim.keymap.set
            s(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr })
        end

        client.server_capabilities.documentFormattingProvider = false
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local fzf = require('fzf-lua')

        set('grr', fzf.lsp_references, 'references')
        set('grd', fzf.lsp_definitions, 'definitions')
        set('gri', fzf.lsp_implementations, 'implementations')
        set('gry', fzf.lsp_typedefs, 'typedefs')
        set('gra', fzf.lsp_code_actions, 'code actions')
        set('grc', fzf.lsp_incoming_calls, 'incoming calls')
        set('grn', vim.lsp.buf.rename, 'rename symbol')
        set('grC', fzf.lsp_outgoing_calls, 'outgoing calls')
        set('grs', fzf.lsp_document_symbols, 'document symbols')
        set('grS', fzf.lsp_workspace_symbols, 'workspace symbols')
        set('grx', fzf.lsp_document_diagnostics, 'documet diagnostics')
        set('grX', fzf.lsp_workspace_diagnostics, 'workspace diagnostics')
        set('<C-k>', vim.lsp.buf.signature_help, 'signature help', 'i')
    end

    require('mason-lspconfig').setup({
        handlers = {
            function(server_name)
                local server = require('tools').servers[server_name] or {}
                server.capabilities = capabilities
                require('lspconfig')[server_name].setup(server)
            end,
        },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(e)
            local client = vim.lsp.get_client_by_id(e.data.client_id)
            if not client then return end
            on_attach(client, e.buf)
        end,
    })
end
