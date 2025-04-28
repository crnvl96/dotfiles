local function on_attach(client, bufnr)
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end

    local function feedkeys(keys, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), mode or 'n', true)
    end

    local set = function(lhs, rhs, opts, mode)
        opts = vim.tbl_extend('error', opts or {}, { buffer = bufnr })
        mode = mode or 'n'
        return vim.keymap.set(mode, lhs, rhs, opts)
    end

    set('E', vim.diagnostic.open_float)
    set('K', vim.lsp.buf.hover)
    set('ga', vim.lsp.buf.code_action)
    set('gn', vim.lsp.buf.rename)
    set('gd', vim.lsp.buf.definition)
    set('gD', vim.lsp.buf.declaration)
    set('gr', vim.lsp.buf.references, { nowait = true })
    set('gi', vim.lsp.buf.implementation)
    set('gy', vim.lsp.buf.type_definition)
    set('ge', vim.diagnostic.setqflist)
    set('gs', vim.lsp.buf.document_symbol)
    set('gS', vim.lsp.buf.workspace_symbol)
    -- set('g=', vim.lsp.buf.format)


    -- stylua: ignore
    if client:supports_method('textDocument/completion') then
        local trigger = client.server_capabilities.completionProvider
        trigger.triggerCharacters = vim.split('abcdefghijklmnopqrstuvwxyz:.', '')

        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })


        set('<CR>', function() return pumvisible() and '<C-y>' or '<cr>' end, { expr = true }, 'i')
        set('<C-n>', function() feedkeys('<Tab>', 't') end, {}, 'c')
        set('<C-p>', function() feedkeys('<S-Tab>', 't') end, {}, 'c')
        set('<C-u>', '<C-x><C-n>', {}, 'i')
        set('<C-Space>', function() return pumvisible() and '<C-e>' or vim.lsp.completion.get() end, { expr = true }, 'i')
        set('<C-n>', function() return pumvisible() and feedkeys('<C-n>') or vim.lsp.completion.get() end, { expr = true },
            'i')
        set('<C-p>', function() return pumvisible() and feedkeys('<C-p>') or vim.lsp.completion.get() end, { expr = true },
            'i')

        set('<Tab>', function()
            if pumvisible() then
                feedkeys('<C-n>')
            else
                feedkeys('<Tab>')
            end
        end, {}, { 'i', 's' })

        set('<S-Tab>', function()
            if pumvisible() then
                feedkeys('<C-p>')
            else
                feedkeys('<S-Tab>')
            end
        end, {}, { 'i', 's' })

        vim.opt.completeopt:append('fuzzy,noselect,menu,menuone,noinsert')
        vim.opt.wildoptions:append('fuzzy')
    end

    if client:supports_method('textDocument/foldingRange') then
        vim.wo[vim.api.nvim_get_current_win()][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    else
        vim.wo[vim.api.nvim_get_current_win()][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
end

-- Handle dynamic capabilities of lsp servers
local signature = vim.lsp.protocol.Methods.client_registerCapability
local register_capability = vim.lsp.handlers[signature] -- Store the method's original signature here
vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    on_attach(client, vim.api.nvim_get_current_buf()) -- Call the default `on_attach` function
    return register_capability(err, res, ctx) -- Call the original method's signature
end

-- Event that handles LSP Attach
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end
        on_attach(client, args.buf)
    end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('crnvl96-restore-cursor', {}),
    callback = function(e)
        -- Restore cursor position when enteting a buffer
        pcall(vim.api.nvim_win_set_cursor, vim.fn.bufwinid(e.buf), vim.api.nvim_buf_get_mark(e.buf, [["]]))
    end,
})
