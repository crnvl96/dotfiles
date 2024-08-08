local add = MiniDeps.add
local buf = vim.lsp.buf
local au = vim.api.nvim_create_autocmd
local tools = require('tools')

local function on_attach(client, bufnr)
    local function set(lhs, rhs, desc, mode)
        local s = vim.keymap.set
        s(mode or 'n', lhs, rhs, { desc = desc, buffer = bufnr })
    end

    local fzf = require('fzf-lua')

    client.server_capabilities.documentFormattingProvider = false
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    set('grr', fzf.lsp_references, 'references')
    set('grd', fzf.lsp_definitions, 'definitions')
    set('gri', fzf.lsp_implementations, 'implementations')
    set('gry', fzf.lsp_typedefs, 'typedefs')
    set('gra', fzf.lsp_code_actions, 'code actions')
    set('grc', fzf.lsp_incoming_calls, 'incoming calls')
    set('grC', fzf.lsp_outgoing_calls, 'outgoing calls')
    set('grs', fzf.lsp_document_symbols, 'document symbols')
    set('grS', fzf.lsp_workspace_symbols, 'workspace symbols')
    set('grx', fzf.lsp_document_diagnostics, 'documet diagnostics')
    set('grX', fzf.lsp_workspace_diagnostics, 'workspace diagnostics')
    set('<C-k>', buf.signature_help, 'signature help', 'i')
end

return function()
    add({
        source = 'neovim/nvim-lspconfig',
        depends = {
            { source = 'williamboman/mason-lspconfig.nvim' },
            { source = 'williamboman/mason.nvim' },
            { source = 'hrsh7th/cmp-nvim-lsp' },
            { source = 'WhoIsSethDaniel/mason-tool-installer.nvim' },
        },
    })

    local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
    )

    require('mason-lspconfig').setup({
        handlers = {
            function(server_name)
                local server = tools.servers[server_name] or {}
                server.capabilities = capabilities
                require('lspconfig')[server_name].setup(server)
            end,
        },
    })

    au('LspAttach', {
        callback = function(e)
            local client = vim.lsp.get_client_by_id(e.data.client_id)
            if not client then return end
            on_attach(client, e.buf)
        end,
    })
end
