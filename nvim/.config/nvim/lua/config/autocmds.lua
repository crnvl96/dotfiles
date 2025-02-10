Utils.Group('crnvl96-resize-splits', function(g)
    vim.api.nvim_create_autocmd('VimResized', {
        group = g,
        callback = function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd('tabdo wincmd =')
            vim.cmd('tabnext ' .. current_tab)
        end,
    })
end)

Utils.Group('crnvl96-auto-create-dirs', function(g)
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = g,
        callback = function(e)
            if e.match:match('^%w%w+:[\\/][\\/]') then return end
            local file = vim.uv.fs_realpath(e.match) or e.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
        end,
    })
end)

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
        callback = function() vim.cmd('cwindow') end,
    })

    vim.api.nvim_create_autocmd('QuickFixCmdPost', {
        group = g,
        pattern = 'l*',
        callback = function() vim.cmd('lwindow') end,
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

Utils.Group('crnvl96-scrolloff', function(g)
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'WinScrolled' }, {
        group = g,
        callback = function()
            if vim.api.nvim_win_get_config(0).relative ~= '' then
                return -- Ignore floating windows
            end

            local win_height = vim.fn.winheight(0)
            local scrolloff = math.min(vim.o.scrolloff, math.floor(win_height / 2))
            local visual_distance_to_eof = win_height - vim.fn.winline()

            if visual_distance_to_eof < scrolloff then
                local win_view = vim.fn.winsaveview()
                vim.fn.winrestview({ topline = win_view.topline + scrolloff - visual_distance_to_eof })
            end
        end,
    })
end)

Utils.Group('crnvl96-cmdline', function(g)
    vim.api.nvim_create_autocmd('CmdlineEnter', {
        group = g,
        command = ':set cmdheight=1',
    })

    vim.api.nvim_create_autocmd('CmdlineLeave', {
        group = g,
        command = ':set cmdheight=0',
    })

    vim.api.nvim_create_autocmd('BufWritePost', {
        group = g,
        pattern = { '*' },
        command = 'redrawstatus',
    })
end)

Utils.Group('crnvl96-hlsearch', function(g)
    vim.api.nvim_create_autocmd('InsertEnter', {
        group = g,
        callback = function()
            vim.schedule(function() vim.cmd('nohlsearch') end)
        end,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
        group = g,
        callback = function()
            -- No bloat lua adpatation of: https://github.com/romainl/vim-cool
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
            local is_terminal = vim.api.nvim_get_option_value('buftype', { buf = 0 }) == 'terminal'

            vim.o.number = not is_terminal
            vim.o.cursorline = false
            vim.o.relativenumber = not is_terminal
            vim.o.signcolumn = is_terminal and 'no' or 'yes'

            local code_term_esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)
            for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
                vim.keymap.set('t', '<C-' .. key .. '>', function()
                    local code_dir = vim.api.nvim_replace_termcodes('<C-' .. key .. '>', true, true, true)
                    vim.api.nvim_feedkeys(code_term_esc .. code_dir, 't', true)
                end, { noremap = true })
            end

            if vim.bo.filetype == '' then
                vim.api.nvim_set_option_value('filetype', 'terminal', { buf = event.buf })
                vim.cmd.startinsert()
            end
        end,
    })
end)
