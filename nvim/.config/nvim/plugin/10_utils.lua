local build = function(p, cmd)
    vim.notify('Building ' .. p.name, vim.log.levels.INFO)

    local obj = vim.system(cmd, { cwd = p.path }):wait()

    if obj.code == 0 then
        vim.notify('Finished building ' .. p.name, vim.log.levels.INFO)
    else
        vim.notify('Failed building' .. p.name, vim.log.levels.ERROR)
    end
end

ReadFromFile = function(f)
    local path = vim.fn.stdpath('config') .. '/static/api_keys/' .. f
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

OnAttach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    vim.keymap.set('n', 'E', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Eval', buffer = bufnr })
    vim.keymap.set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'Eval', buffer = bufnr })
    vim.keymap.set('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Actions', buffer = bufnr })
    vim.keymap.set('n', 'gn', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename', buffer = bufnr })

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto Definition' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { nowait = true, desc = 'References' })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Goto Implementation' })
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { desc = 'Goto T[y]pe Definition' })
    vim.keymap.set('n', 'ge', vim.diagnostic.setqflist, { desc = 'Diagnostics' })
    vim.keymap.set('n', 'gs', vim.lsp.buf.document_symbol, { desc = 'LSP Symbols' })
    vim.keymap.set('n', 'gS', vim.lsp.buf.workspace_symbol, { desc = 'LSP Workspace Symbols' })

    if client:supports_method('textDocument/completion') then
        client.server_capabilities.completionProvider.triggerCharacters = vim.split('qwertyuiopasdfghjklzxcvbnm. ', '')
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

        local function keymap(lhs, rhs, opts, mode)
            opts = type(opts) == 'string' and { desc = opts }
                or vim.tbl_extend('error', opts --[[@as table]], { buffer = bufnr })
            mode = mode or 'n'
            vim.keymap.set(mode, lhs, rhs, opts)
        end

        ---For replacing certain <C-x>... keymaps.
        ---@param keys string
        local function feedkeys(keys)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
        end

        ---Is the completion menu open?
        local function pumvisible() return tonumber(vim.fn.pumvisible()) ~= 0 end

        keymap('<cr>', function() return pumvisible() and '<C-y>' or '<cr>' end, { expr = true }, 'i')
        keymap('/', function() return pumvisible() and '<C-e>' or '/' end, { expr = true }, 'i')

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

        keymap('<C-u>', '<C-x><C-n>', { desc = 'Buffer completions' }, 'i')
    end

    if client:supports_method('textDocument/foldingRange') then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
end

CodecompanionStatus = {
    active_requests = {},
    count = 0,
}

function StatuslineDiagnostics()
    local diagnostics = vim.diagnostic.get(0)
    local counts = { 0, 0, 0, 0 }

    for _, diagnostic in ipairs(diagnostics) do
        counts[diagnostic.severity] = counts[diagnostic.severity] + 1
    end

    local icons = { 'E:', 'W:', 'I:', 'H:' }
    local result = {}

    for i, count in ipairs(counts) do
        if count > 0 then table.insert(result, icons[i] .. count) end
    end

    return #result > 0 and table.concat(result, ' ') or ''
end

function CodeCompanionStatusline()
    if CodecompanionStatus.count > 0 then
        return ' 󱜚  [cc running...]' -- Showing CodeCompanion is active
    else
        return ''
    end
end

CursorPreYank = nil

function YankCmd(cmd)
    return function()
        CursorPreYank = vim.api.nvim_win_get_cursor(0)
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
            MiniDeps.later(function() build(p, { ASDFNode .. 'npm', 'install', '-g', 'mcp-hub@latest' }) end)
        end,
        post_checkout = function(p)
            MiniDeps.later(function() build(p, { ASDFNode .. 'npm', 'install', '-g', 'mcp-hub@latest' }) end)
        end,
    },
    blink = {
        post_install = function(p)
            MiniDeps.later(function() build(p, { ASDFRust .. 'cargo', 'build', '--release' }) end)
        end,
        post_checkout = function(p)
            MiniDeps.later(function() build(p, { ASDFRust .. 'cargo', 'build', '--release' }) end)
        end,
    },
}
