vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.oil_show_file_detail = false
vim.g.disable_autoformat = false

vim.o.autoindent = true
vim.o.autoread = true
vim.o.breakindent = true
vim.o.clipboard = 'unnamedplus'
vim.o.cmdheight = 1
vim.o.conceallevel = 0
vim.o.cursorline = false
vim.o.expandtab = true
vim.opt.fillchars:append('eob: ')
vim.o.foldcolumn = '0'
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.o.grepprg = vim.env.HOME .. '/.asdf/shims/rg --vimgrep'
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.laststatus = 0
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:2,hor:6'
vim.o.number = true
vim.o.numberwidth = 3
vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showcmd = false
vim.o.showmode = false
vim.o.sidescrolloff = 8
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.spell = false
vim.o.spell = false
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.swapfile = false
vim.o.switchbuf = 'useopen'
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.timeoutlen = 1000
vim.o.undofile = true
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.wrap = false
vim.o.writebackup = false
vim.o.diffopt = 'filler,internal,closeoff,algorithm:histogram,context:5,linematch:60'

vim.cmd([[colorscheme ham]])

vim.opt.completeopt:append('fuzzy')
vim.opt.wildoptions:append('fuzzy')

vim.diagnostic.config({
    float = { border = 'rounded', source = true },
    virtual_text = true,
    update_in_insert = true,
    virtual_lines = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = 'E',
            [vim.diagnostic.severity.WARN] = 'W',
            [vim.diagnostic.severity.HINT] = 'H',
            [vim.diagnostic.severity.INFO] = 'I',
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        },
    },
})

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

local methods = vim.lsp.protocol.Methods
local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)

local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
    show = function(ns, bufnr, diagnostics, opts)
        table.sort(diagnostics, function(diag1, diag2) return diag1.severity > diag2.severity end)
        return show_handler(ns, bufnr, diagnostics, opts)
    end,
    hide = hide_handler,
}

vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
    contents = vim.lsp.util._normalize_markdown(contents, {
        width = vim.lsp.util._make_floating_popup_size(contents, opts),
    })
    vim.bo[bufnr].filetype = 'markdown'
    vim.treesitter.start(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

    return contents
end

local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end

    Utils.OnAttach(client, vim.api.nvim_get_current_buf())

    return register_capability(err, res, ctx)
end

for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
    local lhs = '<C-' .. key .. '>'
    vim.keymap.set({ 'n', 'v', 'i' }, lhs, '<Esc><C-w><C-' .. key .. '>')
end

vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>w<CR><Esc>')

vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

vim.keymap.set('n', 'gp', '`[v`]', { desc = 'Select pasted text' })

vim.keymap.set('n', '#', '#zzzv')
vim.keymap.set('n', '*', '*zzzv')
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-w>+', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-w>-', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-w><', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>')

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zzzv'", { expr = true })
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zzzv'", { expr = true })
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')
vim.keymap.set('x', 'p', 'P')

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
                end, { noremap = true })
            end

            if vim.bo.filetype == '' then
                vim.api.nvim_set_option_value('filetype', 'terminal', { buf = event.buf })
                vim.cmd.startinsert()
            end
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
