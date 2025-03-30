Build = function(p, cmd)
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

    if client:supports_method('textDocument/completion') then
        client.server_capabilities.completionProvider.triggerCharacters = vim.split('qwertyuiopasdfghjklzxcvbnm. ', '')
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
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
            MiniDeps.later(function() Build(p, { 'npm', 'install', '-g', 'mcp-hub@latest' }) end)
        end,
        post_checkout = function(p)
            MiniDeps.later(function() Build(p, { 'npm', 'install', '-g', 'mcp-hub@latest' }) end)
        end,
    },
}
