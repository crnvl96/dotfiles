Utils.Group('crnvl96-checktime', function(g)
    vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
        group = g,
        callback = function()
            if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
        end,
    })
end)

Utils.Group('crnvl96-restore-cursor', function(g)
    vim.api.nvim_create_autocmd('BufReadPost', {
        group = g,
        callback = function(e)
            local position = vim.api.nvim_buf_get_mark(e.buf, [["]])
            local winid = vim.fn.bufwinid(e.buf)
            pcall(vim.api.nvim_win_set_cursor, winid, position)
        end,
    })
end)

Utils.Group('crnvl96-open-list', function(g)
    vim.api.nvim_create_autocmd('QuickFixCmdPost', {
        group = g,
        pattern = '[^lc]*',
        callback = function() vim.cmd('botright cwindow') end,
    })

    vim.api.nvim_create_autocmd('QuickFixCmdPost', {
        group = g,
        pattern = 'l*',
        callback = function() vim.cmd('botright lwindow') end,
    })
end)

Utils.Group('crnvl96-yank', function(g)
    local cursorPreYank

    local function yank_cmd(cmd)
        return function()
            cursorPreYank = vim.api.nvim_win_get_cursor(0)
            return cmd
        end
    end

    vim.keymap.set('n', 'Y', yank_cmd('yg_'), { expr = true })
    vim.keymap.set({ 'n', 'x' }, 'y', yank_cmd('y'), { expr = true })

    vim.api.nvim_create_autocmd('TextYankPost', {
        group = g,
        callback = function()
            (vim.hl or vim.highlight).on_yank()
            if vim.v.event.operator == 'y' and cursorPreYank then vim.api.nvim_win_set_cursor(0, cursorPreYank) end
        end,
    })
end)

Utils.Group('crnvl96-on-lsp-attach', function(g)
    vim.api.nvim_create_autocmd('LspAttach', {
        group = g,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then return end
            Utils.OnAttach(client, args.buf)
        end,
    })
end)

Utils.Group('crnvl96-term', function(g)
    vim.api.nvim_create_autocmd('WinEnter', {
        group = g,
        callback = function()
            if vim.bo.filetype == 'terminal' then vim.cmd.startinsert() end
        end,
    })

    vim.api.nvim_create_autocmd('TermOpen', {
        group = g,
        callback = function(event)
            local buftype = vim.api.nvim_get_option_value('buftype', { buf = 0 })
            local is_terminal = buftype == 'terminal'

            vim.o.number = not is_terminal
            vim.o.cursorline = false
            vim.o.relativenumber = not is_terminal
            vim.o.signcolumn = is_terminal and 'no' or 'yes'

            local code_term_esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)

            for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
                vim.keymap.set('t', '<C-' .. key .. '>', function()
                    local code_dir = vim.api.nvim_replace_termcodes('<C-' .. key .. '>', true, true, true)
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
end)

Utils.Group('crnvl96-hlsearch', function(g)
    vim.api.nvim_create_autocmd('InsertEnter', {
        group = g,
        callback = function()
            vim.schedule(function() vim.cmd('nohlsearch') end)
        end,
    })

    -- lua adpatation of: https://github.com/romainl/vim-cool
    vim.api.nvim_create_autocmd('CursorMoved', {
        group = g,
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
end)
