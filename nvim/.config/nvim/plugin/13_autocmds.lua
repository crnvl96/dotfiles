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
        OnAttach(client, args.buf)
    end,
})

vim.api.nvim_create_autocmd('WinEnter', {
    group = vim.api.nvim_create_augroup('crnvl96-term-startinsert', {}),
    callback = function()
        if vim.bo.filetype == 'terminal' then vim.cmd.startinsert() end
    end,
})

vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('crnvl96-term-handle-keys', {}),
    callback = function(event)
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })
        local is_terminal = buftype == 'terminal'

        vim.o.number = not is_terminal
        vim.o.cursorline = false
        vim.o.relativenumber = not is_terminal
        vim.o.signcolumn = is_terminal and 'no' or 'yes'

        local code_term_esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)

        for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
            vim.keymap.set('t', '<C-w>' .. key, function()
                local code_dir = vim.api.nvim_replace_termcodes('<C-w>' .. key, true, true, true)
                vim.api.nvim_feedkeys(code_term_esc .. code_dir, 't', true)
                vim.cmd([[checktime]]) -- Reload nvim to sync any file changed by a terminal cmd
            end, { noremap = true })
        end

        vim.keymap.set('t', '<C-t>', function() vim.api.nvim_feedkeys(code_term_esc, 't', true) end)

        if vim.bo.filetype == '' then
            vim.api.nvim_set_option_value('filetype', 'terminal', { buf = event.buf })
            vim.cmd.startinsert()
        end
    end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
    group = vim.api.nvim_create_augroup('crnvl96-hlsearch-on-insert', {}),
    callback = function()
        vim.schedule(function() vim.cmd('nohlsearch') end)
    end,
})

-- lua adpatation of: https://github.com/romainl/vim-cool
vim.api.nvim_create_autocmd('CursorMoved', {
    group = vim.api.nvim_create_augroup('crnvl96-hlsearch-on-move', {}),
    callback = function()
        local view, rpos = vim.fn.winsaveview(), vim.fn.getpos('.')
        -- Move the cursor to a position where (whereas in active search) pressing `n`
        -- brings us to the original cursor position, in a forward search / that means
        -- one column before the match, in a backward search ? we move one col forward
        vim.cmd(
            string.format(
                'silent! keepjumps go%s',
                (vim.fn.line2byte(view.lnum) + view.col + 1 - (vim.v.searchforward == 1 and 2 or 0))
            )
        )
        -- Attempt to goto next match, if we're in an active search cursor position
        -- should be equal to original cursor position
        local ok, _ = pcall(vim.cmd, 'silent! keepjumps norm! n')
        local insearch = ok
            and (function()
                local npos = vim.fn.getpos('.')
                return npos[2] == rpos[2] and npos[3] == rpos[3]
            end)()
        -- restore original view and position
        vim.fn.winrestview(view)
        if not insearch then vim.schedule(function() vim.cmd('nohlsearch') end) end
    end,
})
