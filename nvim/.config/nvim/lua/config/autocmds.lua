Utils.Group('crnvl96-auto-resize-window-splits', function(g)
    vim.api.nvim_create_autocmd('VimResized', {
        group = g,
        callback = function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd('tabdo wincmd =')
            vim.cmd('tabnext ' .. current_tab)
        end,
    })
end)

Utils.Group('crnvl96-auto-sync', function(g)
    vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
        group = g,
        callback = function()
            if vim.o.buftype ~= 'nofile' then vim.cmd('checktime') end
        end,
    })
end)

Utils.Group('crnvl96-auto-restore-last-position', function(g)
    vim.api.nvim_create_autocmd('BufReadPost', {
        group = g,
        callback = function(e)
            local position = vim.api.nvim_buf_get_mark(e.buf, [["]])
            local winid = vim.fn.bufwinid(e.buf)
            pcall(vim.api.nvim_win_set_cursor, winid, position)
        end,
    })
end)

Utils.Group('crnvl96-auto-open-qf-list', function(g)
    vim.api.nvim_create_autocmd('QuickFixCmdPost', {
        group = g,
        pattern = '[^lc]*',
        callback = function() vim.cmd('cwindow') end,
    })
end)

Utils.Group('crnvl96-auto-open-ll-list', function(g)
    vim.api.nvim_create_autocmd('QuickFixCmdPost', {
        group = g,
        pattern = 'l*',
        callback = function() vim.cmd('lwindow') end,
    })
end)

Utils.Group('crnvl96-handle-hlsearch', function(g)
    vim.api.nvim_create_autocmd('InsertEnter', {
        group = g,
        callback = function()
            vim.schedule(function() vim.cmd('nohlsearch') end)
        end,
    })
end)

Utils.Group('crnvl96-handle-yank', function(g)
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
