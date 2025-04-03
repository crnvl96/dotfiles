vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionRequestStarted',
    group = vim.api.nvim_create_augroup('crnvl96-codecompanion-statusline-start', {}),
    callback = function(e)
        CodecompanionStatus.active_requests[e.data.id] = {
            adapter = e.data.adapter.formatted_name,
            model = e.data.adapter.model,
            strategy = e.data.strategy,
        }

        CodecompanionStatus.count = CodecompanionStatus.count + 1

        vim.cmd('redrawstatus')
    end,
})

vim.api.nvim_create_autocmd('User', {
    pattern = 'CodeCompanionRequestFinished',
    group = vim.api.nvim_create_augroup('crnvl96-codecompanion-statusline-finish', {}),
    callback = function(e)
        if CodecompanionStatus.active_requests[e.data.id] then
            CodecompanionStatus.active_requests[e.data.id] = nil
            CodecompanionStatus.count = CodecompanionStatus.count - 1

            vim.cmd('redrawstatus')
        end
    end,
})

vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
    group = vim.api.nvim_create_augroup('crnvl96-checktime', {}),
    callback = function()
        if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
    end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('crnvl96-restore-cursor', {}),
    callback = function(e)
        local position = vim.api.nvim_buf_get_mark(e.buf, [["]])
        local winid = vim.fn.bufwinid(e.buf)
        pcall(vim.api.nvim_win_set_cursor, winid, position)
    end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = vim.api.nvim_create_augroup('crnvl96-restore-qf', {}),
    pattern = '[^lc]*',
    callback = function() vim.cmd('botright cwindow') end,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = vim.api.nvim_create_augroup('crnvl96-restore-ll', {}),
    pattern = 'l*',
    callback = function() vim.cmd('botright lwindow') end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('crnvl96-yank', {}),
    callback = function()
        (vim.hl or vim.highlight).on_yank()
        if vim.v.event.operator == 'y' and CursorPreYank then vim.api.nvim_win_set_cursor(0, CursorPreYank) end
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        local bufname = vim.api.nvim_buf_get_name(args.buf)

        -- Stop the LSP client on invalid buffers
        -- see https://github.com/neovim/nvim-lspconfig/blob/ff6471d4f837354d8257dfa326b031dd8858b16e/lua/lspconfig/configs.lua#L97-L99
        if #bufname ~= 0 and not BufnameValid(bufname) then
            client.stop()
            return
        end

        OnAttach(client, args.buf)
    end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
    group = vim.api.nvim_create_augroup('crnvl96-hlsearch-on-insert', {}),
    callback = function()
        vim.schedule(function() vim.cmd('nohlsearch') end)
    end,
})
