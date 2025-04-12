---
--- Global constants
---

-- Keep here the initial position of the cursor when starting a yank operation
CursorPreYank = nil

-- Keep here the metatada about the llm request being made by CodeCompanion
CodecompanionStatus = {
    active_requests = {},
    count = 0,
}

---
--- Global functions
---

-- Wrapper to find files using `fd` cli tool
Fd = function(file_pattern, _)
    if file_pattern:sub(1, 1) == '*' then file_pattern = file_pattern:gsub('.', '.*%0') .. '.*' end
    return vim.fn.systemlist(
        'fd --color=never --full-path --type file --hidden --exclude=".git" "' .. file_pattern .. '"'
    )
end

-- Builder used during plugins installation/updates
Build = function(p, cmd)
    vim.notify('Building ' .. p.name, vim.log.levels.INFO)
    local obj = vim.system(cmd, { cwd = p.path }):wait()
    if obj.code == 0 then
        vim.notify('Finished building ' .. p.name, vim.log.levels.INFO)
    else
        vim.notify('Failed building' .. p.name, vim.log.levels.ERROR)
    end
end

-- Read information from local files to avoid exposing them in shell environment
ReadFromFile = function(f)
    local vimstdconf = vim.fn.stdpath('config') -- default nvim config path
    local path = vimstdconf .. '/' .. f
    local file = io.open(path, 'r')
    if not file then return nil end
    local key = file:read('*a'):gsub('%s+$', '')
    file:close()
    if not key then
        vim.notify('Missing file: ' .. f, 'ERROR')
        return nil
    end
    return key
end

-- Function to be called during lsp attach events
OnAttach = function(client, bufnr)
    -- Formatting is handled by conform.nvim
    client.server_capabilities.documentFormattingProvider = false
    -- Range formatting is handled by conform.nvim
    client.server_capabilities.documentRangeFormattingProvider = false

    local set = function(lhs, rhs, opts)
        opts = vim.tbl_extend('error', opts or {}, { buffer = bufnr })
        return vim.keymap.set('n', lhs, rhs, opts)
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

    -- if not, we keep using treesitter based folding
    if client:supports_method('textDocument/foldingRange') then
        vim.wo[vim.api.nvim_get_current_win()][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
end

-- Add buffer diagnostics in the statusline
-- We keep this as a global function to use later in `vim.opt.statusline` setting
function StatuslineDiagnostics()
    local diagnostics = vim.diagnostic.get(0) -- 0 is the current buffer
    local counts = { 0, 0, 0, 0 }
    for _, diagnostic in ipairs(diagnostics) do
        counts[diagnostic.severity] = counts[diagnostic.severity] + 1
    end
    local icons = { 'E:', 'W:', 'I:', 'H:' } -- Icons
    local result = {}
    for i, count in ipairs(counts) do
        if count > 0 then table.insert(result, icons[i] .. count) end
    end
    return #result > 0 and table.concat(result, ' ') or ''
end

-- Add a small hint in the statusline to indicate that the CodeCompanion plugin is running
-- We keep this as a global function to use later in `vim.opt.statusline` setting
function CodeCompanionStatusline()
    if CodecompanionStatus.count > 0 then
        return ' 󱜚  [cc running...]'
    else
        return ''
    end
end

-- Function to handle the yank processes.
-- The base Idea is to avoid moving the cursor position after completing the yank operation
function YankCmd(cmd)
    return function()
        CursorPreYank = vim.api.nvim_win_get_cursor(0) -- Cursor current position
        return cmd
    end
end

-- Prevent lsp to attach to invalid buffers
--
-- https://github.com/neovim/neovim/issues/33061
-- https://www.reddit.com/r/neovim/comments/1jpiz7w/nvim_011_with_native_lsp_doubles_intelephense_ls/
-- see https://github.com/neovim/nvim-lspconfig/blob/ff6471d4f837354d8257dfa326b031dd8858b16e/lua/lspconfig/util.lua#L23-L28
BufnameValid = function(bufname)
    if
        bufname:match('^/')
        or bufname:match('^[a-zA-Z]:')
        or bufname:match('^zipfile://')
        or bufname:match('^tarfile:')
    then
        return true
    end

    return false
end

-- The build configurations to use with MiniDeps plugin.
-- These configurations are mainly used during plugin installation and updates
MiniDepsHooks = {
    treesitter = {
        post_install = function()
            MiniDeps.later(function() vim.cmd('TSUpdate') end)
        end,
        post_checkout = function()
            MiniDeps.later(function() vim.cmd('TSUpdate') end)
        end,
    },
    mcphub = {
        post_install = function(p)
            MiniDeps.later(function() Build(p, { ASDFNode .. 'npm', 'install', '-g', 'mcp-hub@latest' }) end)
        end,
        post_checkout = function(p)
            MiniDeps.later(function() Build(p, { ASDFNode .. 'npm', 'install', '-g', 'mcp-hub@latest' }) end)
        end,
    },
    blink = {
        post_install = function(p)
            MiniDeps.later(function() Build(p, { ASDFRust .. 'cargo', 'build', '--release' }) end)
        end,
        post_checkout = function(p)
            MiniDeps.later(function() Build(p, { ASDFRust .. 'cargo', 'build', '--release' }) end)
        end,
    },
}

vim.g.loaded_netrwPlugin = 1 -- Don't load netrw
vim.g.mapleader = ' ' -- <Space>  as leader key
vim.g.maplocalleader = ',' -- comma as local leader key
vim.g.node_host_prog = NodePath .. '/bin/node' -- Default node version used by nvim

vim.o.findfunc = 'v:lua.Fd' -- Default ":find" function
vim.o.autoindent = true
vim.o.guicursor = ''
vim.o.autoread = true
vim.o.breakindent = true
vim.o.clipboard = 'unnamed'
vim.o.cursorline = true
vim.o.diffopt = 'filler,internal,closeoff,algorithm:histogram,context:5,linematch:60'
vim.o.expandtab = true
vim.o.foldcolumn = '0'
vim.o.foldcolumn = '0'
vim.o.foldenable = true
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
vim.o.foldtext = ''
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.o.grepprg = 'rg --vimgrep --smart-case'
vim.o.makeprg = 'make'
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.laststatus = 2
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.numberwidth = 3
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
vim.o.termguicolors = false
vim.o.timeoutlen = 1000
vim.o.undofile = true
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.winborder = 'single'
vim.o.wrap = false
vim.o.writebackup = false
vim.o.list = false

vim.opt.fillchars:append({ eob = '~', fold = '.' })
vim.o.listchars = table.concat({ 'extends:…', 'nbsp:␣', 'precedes:…', 'tab:  ' }, ',')
vim.opt.completeopt:append('fuzzy,noselect')
vim.opt.wildoptions:append('fuzzy')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

vim.diagnostic.config({
    float = { source = true },
    virtual_text = true,
    update_in_insert = true,
    virtual_lines = false,
    signs = false,
})

vim.lsp.handlers[Methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    OnAttach(client, vim.api.nvim_get_current_buf())
    return RegisterCapability(err, res, ctx)
end

vim.keymap.set('x', 'p', 'P')
vim.keymap.set('c', '<C-n>', '<Tab>')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', '"+y$', { desc = 'Copy to clipboard' })
vim.keymap.set('n', 'gY', ":<C-U>let @+ = expand('%:.')<CR>", { desc = 'Copy file name to default register' })
vim.keymap.set('n', 'gP', '`[v`]', { desc = 'Select pasted text' })
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<C-x>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>w<CR><Esc>')
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-w>+', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-w>-', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-w><', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')
vim.keymap.set('n', 'Y', YankCmd('yg_'), { expr = true })
vim.keymap.set({ 'n', 'x' }, 'y', YankCmd('y'), { expr = true })

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

vim.api.nvim_create_user_command('Grep', function(params)
    if #params.args == 0 then
        print('Error: No arguments provided for Grep')
        return
    end

    vim.cmd('silent grep! ' .. vim.fn.shellescape(params.args))
    vim.cmd('copen')
end, {
    nargs = '*',
    complete = 'file',
})

vim.api.nvim_create_user_command('Make', function(params)
    local args = vim.fn.shellescape(params.args)

    -- The '!' prevents jumping to the first error automatically
    -- Output from make will be captured in the quickfix list
    vim.cmd('make! ' .. args)

    -- Open the quickfix window to display results (errors/warnings)
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd('copen')
    else
        vim.api.nvim_echo({ { 'Make completed successfully', 'Normal' } }, false, {})
    end
end, {
    nargs = '*',
    complete = 'file',
})
