---@diagnostic disable: undefined-global

if true then return end -- Don't execute this file's lua code

if client:supports_method('textDocument/completion') then
    client.server_capabilities.completionProvider.triggerCharacters = vim.split('qwertyuiopasdfghjklzxcvbnm. ', '')
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

    local function keymap(lhs, rhs, opts, mode)
        opts = type(opts) == 'string' and { desc = opts }
            or vim.tbl_extend('error', opts --[[@as table]], { buffer = bufnr })
        mode = mode or 'n'
        vim.keymap.set(mode, lhs, rhs, opts)
    end

    local function feedkeys(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), mode or 'n', true)
    end

    local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end

    keymap('<cr>', function() return pumvisible() and '<C-y>' or '<cr>' end, { expr = true }, 'i')
    keymap('/', function() return pumvisible() and '<C-e>' or '/' end, { expr = true }, 'i')
    keymap('<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' }, 'i')

    keymap('<C-n>', function()
        if pumvisible() then
            feedkeys('<C-n>')
        else
            if next(vim.lsp.get_clients({ bufnr = 0 })) then
                vim.lsp.completion.get()
            else
                if vim.bo.omnifunc == '' then
                    feedkeys('<C-x><C-n>')
                else
                    feedkeys('<C-x><C-o>')
                end
            end
        end
    end, 'Trigger/select next completion', { 'i', 'c' })

    keymap('<C-p>', function()
        if pumvisible() then
            feedkeys('<C-p>')
        else
            if next(vim.lsp.get_clients({ bufnr = 0 })) then
                vim.lsp.completion.get()
            else
                if vim.bo.omnifunc == '' then
                    feedkeys('<C-x><C-n>')
                else
                    feedkeys('<C-x><C-o>')
                end
            end
        end
    end, 'Trigger/select next completion', { 'i', 'c' })
end
